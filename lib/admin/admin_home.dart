import 'package:flutter/material.dart';
import 'package:furniture_store/admin/add_category.dart';
import 'package:furniture_store/admin/admin_orders.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:furniture_store/controllers/categories_controller.dart';
import 'package:get/get.dart';

class AdminHome extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final controller = Get.find<CategoriesController>();
  AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(authController.user["username"].toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => Get.to(AdminOrders()),
                child: Text("View Orders")),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //add category button
            CustomButton(
                onTap: () {
                  Get.bottomSheet(AddCategory(
                    categoryController: TextEditingController(),
                  ));
                },
                label: 'Add Category'),

            //getbuilder for categories

            Obx(() => Column(
                  children: controller.categories.value
                      .map((e) => categoryTile(e))
                      .toList(),
                ))
          ],
        ),
      ),
    );
  }

  Widget categoryTile(category) {
    return InkWell(
      onTap: () => Get.toNamed('/product-screen', arguments: category['id']),
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category['category']),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.bottomSheet(AddCategory(
                  isEdit: true,
                  categoryController: TextEditingController(
                    text: category['category'],
                  ),
                  id: category['id'],
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // controller.deleteCategory(category['id']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
