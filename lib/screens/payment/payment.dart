import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:furniture_store/controllers/order_controller.dart';
import 'package:get/get.dart';
import 'package:khalti/khalti.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Payment extends StatelessWidget {
  final onsuccess;
  Payment({Key? key, this.onsuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.green,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Wallet Payment'),
              Tab(text: 'EBanking'),
              Tab(text: 'MBanking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WalletPayment(
              onsuccess: onsuccess,
            ),
            Banking(paymentType: PaymentType.eBanking),
            Banking(paymentType: PaymentType.mobileCheckout),
          ],
        ),
      ),
    );
  }
}

class WalletPayment extends StatefulWidget {
  final onsuccess;
  const WalletPayment({Key? key, this.onsuccess}) : super(key: key);

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  final orderController = Get.find<OrderController>();
  late final TextEditingController _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
                decoration: const InputDecoration(
                  label: Text('Mobile Number'),
                ),
                controller: _mobileController,
              ),
              TextFormField(
                obscureText: true,
                validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
                decoration: const InputDecoration(
                  label: Text('Khalti MPIN'),
                ),
                controller: _pinController,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  final initiationModel = await Khalti.service.initiatePayment(
                    request: PaymentInitiationRequestModel(
                      amount: 1000,
                      mobile: _mobileController.text,
                      productIdentity: 'dasdasd',
                      productName: 'dsa',
                      transactionPin: _pinController.text,
                      additionalData: {
                        'orders': jsonEncode(orderController.orders.value),
                        'manufacturer': '.',
                      },
                    ),
                  );

                  final otpCode = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String? _otp;
                      return AlertDialog(
                        title: const Text('OTP Sent!'),
                        content: TextField(
                          decoration: const InputDecoration(
                            label: Text('OTP Code'),
                          ),
                          onChanged: (v) => _otp = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context, _otp),
                          )
                        ],
                      );
                    },
                  );

                  if (otpCode != null) {
                    try {
                      final model = await Khalti.service.confirmPayment(
                        request: PaymentConfirmationRequestModel(
                          confirmationCode: otpCode,
                          token: initiationModel.token,
                          transactionPin: _pinController.text,
                        ),
                      );
                      orderController.placeOrder(
                          transaction_token: model.token);

                      debugPrint(model.toString());
                    } catch (e) {
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                child: Text(cartController.cartTotal.value.toStringAsFixed(2)),
              ),
            ],
          ),
        ));
  }
}

class Banking extends StatefulWidget {
  const Banking({Key? key, required this.paymentType}) : super(key: key);

  final PaymentType paymentType;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: Khalti.service.getBanks(paymentType: widget.paymentType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final banks = snapshot.data!.banks;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];

              return ListTile(
                leading: SizedBox.square(
                  dimension: 40,
                  child: Image.network(bank.logo),
                ),
                title: Text(bank.name),
                subtitle: Text(bank.shortName),
                onTap: () async {
                  final mobile = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String? _mobile;
                      return AlertDialog(
                        title: const Text('Enter Mobile Number'),
                        content: TextField(
                          decoration: const InputDecoration(
                            label: Text('Mobile Number'),
                          ),
                          onChanged: (v) => _mobile = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context, _mobile),
                          )
                        ],
                      );
                    },
                  );

                  if (mobile != null) {
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      amount: 1000,
                      mobile: mobile,
                      productIdentity: 'macbook-pro-21',
                      productName: 'Macbook Pro 2021',
                      paymentType: widget.paymentType,
                      returnUrl: 'https://khalti.com',
                    );

                    url_launcher.launch(url);
                  }
                },
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
