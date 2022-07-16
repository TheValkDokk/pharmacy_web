import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_web/constant/constant.dart';

import 'widgets/cart_tile.dart';

class CartWindow extends StatelessWidget {
  const CartWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###');
    return Obx(
      () {
        if (currentOrderController.cartCount <= 0) {
          return Center(
            child: Column(
              children: const [
                Text(
                  'Your Cart is empty',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            height: Get.height * 0.7,
            width: Get.width * 0.7,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectableText(
                      'Total Price: ${formatter.format(currentOrderController.cartPrice.value)},000 VND',
                      style: const TextStyle(fontSize: 20),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.clear),
                      onPressed: () =>
                          currentOrderController.confirmClearCart(),
                      label: const Text("Clear Cart"),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentOrderController.cartCount.value,
                    itemBuilder: (context, index) {
                      return CartTile(index);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
