import 'package:flutter/material.dart';
import 'package:furniture_store/admin/add_product.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/components/product_tile.dart';
import 'package:furniture_store/controllers/products_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final categoryId = Get.arguments;
  final controller = Get.find<ProductController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.filterByCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text('Product Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomButton(
                onTap: () => Get.bottomSheet(AddProduct(
                    categoryId: categoryId,
                    name: TextEditingController(),
                    price: TextEditingController(),
                    des: TextEditingController())),
                label: 'Add Product'),
            Expanded(child: Container(
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
                                onProductDelete: () => productController.deleteItem(
                                    id: productController.filtered[index].id,
                                    categoryId: categoryId),
                                onAdminPress: () => Get.bottomSheet(AddProduct(
                                    productImage:
                                        productController.filtered[index].image,
                                    productId:
                                        productController.filtered[index].id,
                                    isEdit: true,
                                    categoryId: categoryId,
                                    name: TextEditingController(
                                        text: productController
                                            .filtered[index].name),
                                    price: TextEditingController(
                                        text: productController
                                            .filtered[index].price),
                                    des: TextEditingController(
                                        text: productController
                                            .filtered[index].despcription))),
                                product: productController.filtered[index],
                                index: index)
                        ],
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                    ));
              }),
            ))
          ],
        ),
      ),
    );
  }
}
