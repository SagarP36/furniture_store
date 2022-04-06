import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furniture_store/components/custom_textformfield.dart';
import 'package:furniture_store/controllers/products_controller.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final bool isEdit;
  final String? productId;
  final TextEditingController name;
  final TextEditingController price;
  final TextEditingController des;
  final String? productImage;
  final String categoryId;
  const AddProduct({
    Key? key,
    this.isEdit = false,
    this.productId,
    required this.categoryId,
    this.productImage,
    required this.name,
    required this.price,
    required this.des,
  }) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _image;
  ImagePicker picker = ImagePicker();
  XFile? image;
  TextEditingController categoryController = TextEditingController();
  final ProductController productController = Get.find<ProductController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.isEdit ? 'Edit Product' : 'Add Product',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product Name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        controller: widget.name,
                        hintText: 'Please enter product name',
                      ),
                      SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product Description',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        controller: widget.des,
                        hintText: 'Please enter product description',
                      ),
                      SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product Price',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        isPhoneNumber: true,
                        controller: widget.price,
                        hintText: 'Please enter product price',
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        //from gallery
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => onPickFromGallery(),
                                            child: pickerWidget(
                                                title: 'Gallery',
                                                IconData: Icons.image),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => onPickFromGallery(),
                                            child: pickerWidget(
                                                title: 'Camera',
                                                IconData: Icons.camera_alt),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                          },
                          child: Card(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : widget.productImage != null
                                      ? Image.network(
                                          baseUrl + widget.productImage!,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: 200,
                                          height: 200,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              validateImage()) {
                            print('category_id' + widget.categoryId);
                            if (widget.isEdit) {
                              await productController.editItem(
                                  id: widget.productId,
                                  name: widget.name.text,
                                  categoryId: widget.categoryId,
                                  imageFile: image,
                                  des: widget.des.text,
                                  price: widget.price.text,
                                  context: context);
                            } else {
                              await productController.addItem(
                                  name: widget.name.text,
                                  categoryId: widget.categoryId,
                                  imageFile: image,
                                  des: widget.des.text,
                                  price: widget.price.text,
                                  context: context);
                            }
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
              ),
            ),
          )),
    );
  }

  validateImage() {
    if (image == null) {
      Get.snackbar('Error', 'Please select an image',
          duration: Duration(seconds: 2),
          colorText: Colors.white,
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }

  Widget pickerWidget({required title, required IconData IconData}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(IconData, color: Colors.black),
            Text(title),
          ],
        ),
      ),
    );
  }

  onPickFromGallery() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
    } catch (e) {}
    Get.back();
  }

  onPickFromCamera() async {
    try {
      image = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = File(image!.path);
      });
    } catch (e) {}
    Get.back();
  }
}
