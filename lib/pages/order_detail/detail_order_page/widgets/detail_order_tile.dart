import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_web/models/cart.dart';

class DetailOrderTile extends StatelessWidget {
  const DetailOrderTile(this.cart);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###');
    double fontSize = 18;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blue.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              cart.drug.imgUrl,
              height: Get.height * 0.1,
            ),
          ),
          Expanded(
            flex: 4,
            child: SelectableText(
              cart.drug.fullName,
              maxLines: 3,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoSizeText(
              '${formatter.format(cart.drug.price)},000 VND / ${cart.drug.unit}',
              maxLines: 1,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoSizeText(
              'Quantity: ${cart.quantity}',
              maxLines: 1,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
