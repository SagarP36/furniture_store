import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:furniture_store/utils/commons.dart';
import 'package:get/get.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  isLoggedIn() async {
    //delay for 2 seconds
    // await Future.delayed(const Duration(seconds: 2));
    var user = await AuthController().setUser();
    print(user);
    if (user != null) {
      user = jsonDecode(user);
      user['is_admin'] == '1' ? Get.offNamed('/admin') : Get.offNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: customLoader()),
    );
  }
}
