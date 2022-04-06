import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:get/get.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final item;
  const AddToCartBottomSheet({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return addToCartSheet(item);
  }

  Widget addToCartSheet(item) {
    final cartController = Get.find<CartController>();
    cartController.setCartItemsValues(item);
    return Container(
      height: 200,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartController.decreaseQuantity()),
                    Obx(() => Text(cartController.quantity.value.toString(),
                        style: TextStyle(fontSize: 20))),
                    IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartController.increaseQuantity()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                cartController.addToCart();
               
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
