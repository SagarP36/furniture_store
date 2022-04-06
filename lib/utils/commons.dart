import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

void showMessage({required String message, bool isError = false}) {
  Get.snackbar(isError ? 'Error' : 'Success', message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: !isError ? Colors.white : Colors.red,
      colorText: isError ? Colors.white : Colors.black,
      snackStyle: SnackStyle.FLOATING,
      icon: Icon(
        isError ? Icons.error : Icons.check,
        color: isError ? Colors.white : Colors.black,
      ),
      borderRadius: 20,
      margin: const EdgeInsets.all(10));
}

Widget customLoader() {
  return Container(
    width: double.infinity,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
      ],
    ),
  );
}

class Grade {
  final String label;
  final int value;

  Grade({required this.label, required this.value});
}
