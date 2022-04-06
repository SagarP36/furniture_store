import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:furniture_store/controllers/order_controller.dart';
import 'package:furniture_store/screens/payment/payment.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.find<OrderController>();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Cart'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  cartController.clear();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => Column(
                        children: cartController.cart.values.map((item) {
                          return menuItemCard(jsonDecode(item));
                        }).toList(),
                      )),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.bottomSheet(Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  //remove underlines
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your delivery address',
                                  ),
                                  onChanged: (value) {
                                    orderController.address.value = value;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  //remove underlines
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your Phone Number',
                                  ),
                                  //accept only numbers
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    orderController.phone.value = value;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                  onTap: () {
                                    // orderController.placeOrder(
                                    //     transaction_token: 'dsadsa');
                                    if (orderController.validate()) {
                                      Get.to(Payment(
                                          onsuccess: (token) =>
                                              orderController.placeOrder(
                                                  transaction_token: token)));
                                    }
                                  },
                                  label: 'Proceed')
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Obx(() => cartController.cartTotal.value != 0.0
                        ? Container(
                            child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    'Pay: ' +
                                        cartController.cartTotal.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                )),
                          )
                        : SizedBox()),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget menuItemCard(item) {
    final cartController = Get.find<CartController>();
    return Stack(
      children: [
        Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Image.network(
                      baseUrl + item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 1.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(item['name'].toString().toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item['price'].toString(),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.red),
                              )),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () =>
                              cartController.decreaseQuantity(item: item)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item["quantity"].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              cartController.increaseQuantity(item: item)),
                    ),
                  ],
                ),
                const Spacer(),
                Text(item["lineTotal"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
