import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniture_store/components/product_tile.dart';
import 'package:furniture_store/controllers/products_controller.dart';
import 'package:get/get.dart';
import '../colors.dart';

class MainScreen extends StatefulWidget {
  final controller = Get.find<ProductController>();
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  var search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  _middleView(),
                  Obx(() => Container(
                      child: widget.controller.searched.trim() == ""
                          ? all()
                          : searched()))
                ],
              )),
        ),
      ),
    );
  }

  Widget searched() {
    return Expanded(child: Container(
      child: GetX<ProductController>(builder: (productController) {
        return Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  for (var index = 0;
                      index < productController.filtered.length;
                      index++)
                    ProductTile(
                        product: productController.filtered[index],
                        index: index)
                ],
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
            ));
      }),
    ));
  }

  Widget all() {
    return Expanded(child: Container(
      child: GetX<ProductController>(builder: (productController) {
        return Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  for (var index = 0;
                      index < productController.products.length;
                      index++)
                    ProductTile(
                        product: productController.products[index],
                        index: index)
                ],
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
            ));
      }),
    ));
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.gray,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Icon(
            Icons.navigate_before,
            color: AppColors.black,
          ),
        ),
        Container(
          child: SvgPicture.asset(
            "assets/images/signs.svg",
            height: 30,
            width: 20,
          ),
        )
      ],
    );
  }

  Widget _middleView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Furniture Shop",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Get unique furniture for your home",
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: AppColors.gray),
          child: TextField(
            onChanged: (value) =>
                widget.controller.filterbySearch(search: value),
            cursorColor: AppColors.black,
            style: TextStyle(color: AppColors.black, fontSize: 16),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: AppColors.black,
                ),
                hintText: "What are you looking for?",
                hintStyle: TextStyle(color: AppColors.black, fontSize: 16),
                border: InputBorder.none),
          ),
        )
      ],
    );
  }
}
