import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:furniture_store/utils/commons.dart';
import 'package:furniture_store/utils/custom_http.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = [].obs;
  var myoders = [].obs;
  var address = "".obs;
  var phone = "".obs;
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();

//oninit
  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  validate() {
    if (address.value.isEmpty) {
      showMessage(message: "Please enter your address", isError: true);
      return false;
    }
    if (phone.value.isEmpty) {
      showMessage(message: "Please enter your phone number", isError: true);
      return false;
    }
    return true;
  }

  getOrders() async {
    //clear orders
    orders.clear();
    var data = await CustomHttp().get(url: getOrdersApi);
    if (data != null) {
      if (data["success"]) {
        orders.value = data["data"];
        //inverse orders

        orders.value = orders.value.reversed.toList();
        update();
      } else {
        Get.snackbar('Login Failed', data['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', "Something Went Wrong.",
          backgroundColor: Colors.brown, colorText: Colors.white);
    }
  }

  filterMyOrders(orders) async {
    var user = await authController.setUser();
    if (user != null) {
      user = jsonDecode(user);
      myoders.clear();
      await Future.delayed(Duration(milliseconds: 500));
      for (var order in orders) {
        if (order["user_id"] == user["id"]) {
          myoders.add(order);
        }
      }
      update();
    }
  }

  placeOrder({String transaction_token = ''}) async {
    String address = this.address.value + ', ' + phone.value.toString();
    var orderItems = jsonEncode(cartController.cart);
    var user = await authController.setUser();
    user = jsonDecode(user);
    var data = {
      "address": address.toString(),
      "order_items": orderItems,
      "transaction_token": transaction_token.toString(),
      "user_id": user["id"].toString(),
      "method": "1",
      "amount": cartController.cartTotal.value.toString(),
    };
    var response = await CustomHttp().post(url: orderApi, body: data);
    if (response != null) {
      if (response["success"]) {
        await getOrders();
        Get.back();
        Get.back();
        Get.toNamed('/my-orders');
        Get.snackbar('Success', response['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      } else {
        Get.snackbar('Failed', response['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
    }
  }

  changeStatus({required String orderId}) async {
    var response = await CustomHttp()
        .post(url: changeOrderStatusApi, body: {"id": orderId});
    if (response != null) {
      if (response["success"]) {
        await getOrders();
        Get.snackbar('Success', response['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      } else {
        Get.snackbar('Failed', response['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', "Something Went Wrong.",
          backgroundColor: Colors.brown, colorText: Colors.white);
    }
  }
}
