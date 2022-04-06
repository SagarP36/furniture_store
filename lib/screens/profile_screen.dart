import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<AuthController> {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            Center(
                child: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 80,
                    child: SvgPicture.asset(
                      'assets/images/profile.svg',
                    ))),
            SizedBox(height: 30),
            content(title: 'Name :', value: controller.user["name"]),
            content(title: 'Phone :', value: controller.user["phone"]),
            content(title: 'Email:', value: controller.user["username"]),
            content(title: 'Address :', value: controller.user["address"]),

            //logout
            SizedBox(height: 20),
            CustomButton(onTap: () => controller.logout(), label: 'Logout'),
            SizedBox(height: 20),
            CustomButton(
                onTap: () => Get.toNamed('my-orders'), label: 'View Orders'),
          ],
        ),
      ),
    );
  }

  Widget content({required String title, required String value}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Text(value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
