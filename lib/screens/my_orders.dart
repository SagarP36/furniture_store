import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/order_controller.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';

class MyOrders extends GetView<OrderController> {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.filterMyOrders(controller.orders);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text('My orders'),
      ),
      body: Column(
        children: [
          //get builder MyOrders
          GetBuilder<OrderController>(
            init: OrderController(),
            builder: (orderController) => Expanded(
              child: ListView.builder(
                itemCount: orderController.myoders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: orderController.myoders[index]
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
                                orderController.myoders[index]['address']),
                            trailing: Text(
                              orderController.myoders[index]['total'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            // ignore: unrelated_type_equality_checks
                            subtitle: Text(orderController.myoders[index]
                                        ['delivery_status'] ==
                                    '1'
                                ? "Delivered"
                                : "Pending"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Items: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          //products
                          if (orderController.myoders[index]['products'] !=
                              null)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderController
                                  .myoders[index]['products'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Image.network(
                                        "$baseUrl/" +
                                            orderController.myoders[index]
                                                ['products'][index]['image'],
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      ),
                                      title: Text(
                                        orderController.myoders[index]
                                                ['products'][index]['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      trailing: Text(
                                        'QTY: ' +
                                            orderController.myoders[index]
                                                ['products'][index]['quantity'],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
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
