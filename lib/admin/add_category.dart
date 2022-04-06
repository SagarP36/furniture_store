import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/categories_controller.dart';
import 'package:get/get.dart';

class AddCategory extends StatefulWidget {
  final bool isEdit;
  final TextEditingController categoryController;
  final String? id;
  const AddCategory({
    Key? key,
    this.isEdit = false,
    this.id,
    required this.categoryController,
  }) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final controller = Get.find<CategoriesController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.isEdit ? 'Edit Category' : 'Add Category',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: widget.categoryController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Category Name',
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.isEdit) {
                        controller.updateCategory(
                            category: widget.categoryController.text,
                            id: widget.id!);
                      } else {
                        controller.addCategory(
                            category: widget.categoryController.text);
                      }
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Center(
                            child: Text(widget.isEdit ? 'Update' : 'Add'))),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                ]),
          )),
    );
  }
}
