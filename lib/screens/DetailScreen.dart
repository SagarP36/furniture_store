import 'package:flutter/material.dart';
import 'package:furniture_store/components/add_to_cart_bottomsheet.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/model/product.dart';
import 'package:furniture_store/utils/apis.dart';
import 'package:get/get.dart';

import '../colors.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  final Product product;
  int index;

  DetailScreen({required this.product, required this.index});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SafeArea(
                child: Column(
              children: [
                _itemImage(),
              ],
            )),
            Expanded(child: _bottomSheet()),
          ],
        ),
      ),
      bottomNavigationBar: _bottomAddToCart(),
    );
  }

  Widget _itemImage() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              child: Hero(
                tag: widget.product.id + '_image',
                child: Image.network(
                  baseUrl + widget.product.image,
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            top: 15,
            left: 15,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.navigate_before,
                    color: AppColors.black,
                    size: 40,
                  ),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white70, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                widget.product.name,
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    letterSpacing: 1.1),
              ),
              Spacer(),
              Text(
                "\Rs: " + widget.product.price,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontFamily: "Raleway",
                    color: Colors.red),
              )
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Product Description",
            style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.product.despcription,
            style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Colors.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.remove,
                color: AppColors.black,
                size: 20,
              ),
              SizedBox(width: 15),
              Text(
                "5",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.add,
                color: AppColors.black,
                size: 20,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomAddToCart() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white70, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Row(
        children: [
          Expanded(
              child: CustomButton(
                  onTap: () {
                    Get.bottomSheet(AddToCartBottomSheet(
                      item: widget.product,
                    ));
                  },
                  label: 'Add to cart')),
        ],
      ),
    );
  }
}
