import 'package:flutter/material.dart';
import 'package:furniture_store/admin/admin_home.dart';
import 'package:furniture_store/admin/products_screen.dart';
import 'package:furniture_store/auth_checker.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:furniture_store/controllers/categories_controller.dart';
import 'package:furniture_store/controllers/order_controller.dart';
import 'package:furniture_store/controllers/products_controller.dart';
import 'package:furniture_store/screens/home_screeen.dart';
import 'package:furniture_store/screens/login_screen.dart';
import 'package:furniture_store/screens/my_orders.dart';
import 'package:furniture_store/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:khalti/khalti.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(CategoriesController());
  await Khalti.init(
    publicKey: 'test_public_key_03e1517bb87b4201abf28f2d74bb33d5',
    enabledDebugging: true,
  );
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    // transition slow
    transitionDuration: Duration(milliseconds: 1000),
    // default transition
    defaultTransition: Transition.fade,
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/',
        page: () => AuthChecker(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
      ),
      GetPage(
        name: '/signup',
        page: () => SignupScreen(),
      ),
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
      ),
      GetPage(
        name: '/admin',
        page: () => AdminHome(),
      ),
      GetPage(
        name: '/product-screen',
        page: () => ProductScreen(),
      ),
      GetPage(
        name: '/my-orders',
        page: () => MyOrders(),
      ),
    ],
  ));
}
