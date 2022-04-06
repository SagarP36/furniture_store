import 'package:flutter/material.dart';
import 'package:furniture_store/colors.dart';
import 'package:furniture_store/components/add_to_cart_bottomsheet.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:furniture_store/model/product.dart';
import 'package:furniture_store/screens/DetailScreen.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final onAdminPress;
  final onProductDelete;
  final authController = Get.find<AuthController>();
  final int index;

  final List<Color> colors_light = <Color>[
    AppColors.light_yellow,
    AppColors.light_y,
    AppColors.light_blue,
    AppColors.light_pink,
    AppColors.light_green,
    AppColors.light_p
  ];
  final List<Color> colors_dark = <Color>[
    AppColors.dark_yellow,
    AppColors.dark_y,
    AppColors.dark_blue,
    AppColors.dark_pink,
    AppColors.dark_green,
    AppColors.dark_p
  ];

  ProductTile({
    Key? key,
    required this.product,
    required this.index,
    this.onAdminPress,
    this.onProductDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailScreen(
          product: product,
          index: index,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: product.id + '_image',
                  child: Image.network(
                    baseUrl + product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _itemTopView(index),
              SizedBox(height: 10),
              _columnOfDescription(index),
              SizedBox(height: 10),
              _bottomofItem(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemTopView(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            product.name.toUpperCase(),
            style: TextStyle(
                fontSize: 12, color: Colors.black, fontFamily: "Sora"),
          ),
          if (authController.user.value["is_admin"] == '1')
            InkWell(
              onTap: onProductDelete,
              child: CircleAvatar(
                backgroundColor: AppColors.light_pink,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _columnOfDescription(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10, top: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.despcription,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontFamily: "Sora",
                height: 1.2,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomofItem(int index) {
    print(authController.user["is_admin"]);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Text(
            'Rs. ' + product.price.toString(),
            style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w300,
                fontFamily: "Poppins"),
          ),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            if (authController.user.value["is_admin"] == '1') {
              onAdminPress();
            } else {
              Get.bottomSheet(AddToCartBottomSheet(
                item: product,
              ));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              authController.user.value["is_admin"] != '1'
                  ? Icons.add
                  : Icons.edit,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
