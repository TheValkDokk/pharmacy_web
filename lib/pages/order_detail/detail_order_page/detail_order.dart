import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/models/order.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../../models/cart.dart';
import 'widgets/detail_order_panel.dart';
import 'widgets/detail_order_tile.dart';

class DetailOrder extends StatelessWidget {
  const DetailOrder();

  @override
  Widget build(BuildContext context) {
    final Order order = Get.arguments as Order;
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: DetailOrderList(order.listCart),
              ),
              Expanded(
                flex: 5,
                child: DetailOrderPanel(order),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailOrderList extends StatelessWidget {
  const DetailOrderList(this.carts);

  final List<Cart> carts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        return DetailOrderTile(carts[index]);
      },
    );
  }
}
