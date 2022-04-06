import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/order_controller.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';

class AdminOrders extends GetView<OrderController> {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.black45,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GetBuilder<OrderController>(
            init: OrderController(),
            builder: (orderController) => Expanded(
              child: ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  return Stack(
                    //allow overflow
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: orderController.orders[index]
                                        ['delivery_status'] ==
                                    '1'
                                ? Colors.blueGrey[100]
                                : Colors.orange[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Address: ' +
                                    orderController.orders[index]['address']),
                                trailing: Text(
                                  orderController.orders[index]['total'],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                // ignore: unrelated_type_equality_checks
                                subtitle: Text(orderController.orders[index]
                                            ['delivery_status'] ==
                                        '1'
                                    ? "Delivered"
                                    : "Pending"),
                              ),
                              //products
                              if (orderController.orders[index]['products'] !=
                                  null)
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: orderController
                                      .orders[index]['products'].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Image.network(
                                            "$baseUrl/" +
                                                orderController.orders[index]
                                                        ['products'][index]
                                                    ['image'],
                                            height: 50,
                                            width: 50,
                                          ),
                                          title: Text(
                                            orderController.orders[index]
                                                ['products'][index]['name'],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          trailing: Text(
                                            orderController.orders[index]
                                                ['products'][index]['quantity'],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: -8,
                          right: 20,
                          child: CircleAvatar(
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.bottomSheet(Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        //change status
                                        const Text(
                                          'Change Status To:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        //delivered
                                        ElevatedButton(
                                          onPressed: () {
                                            orderController.changeStatus(
                                                orderId: orderController
                                                    .orders[index]['id']);
                                            Get.back();
                                          },
                                          child: Text(
                                              orderController.orders[index]
                                                          ['delivery_status'] ==
                                                      '1'
                                                  ? "Pending"
                                                  : "Delivered"),
                                        ),
                                        //pending
                                      ],
                                    ),
                                  ),
                                ));
                              },
                            ),
                          ))
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
