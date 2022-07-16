import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../controllers/order_history_controller.dart';
import 'widgets/order_history_tile.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: GetX<OrderController>(
          init: OrderController(),
          builder: (ordersCtl) {
            if (ordersCtl.orders.isEmpty) {
              return const Center(
                child: Text(
                  'You don\'t have any order',
                  style: TextStyle(fontSize: 25),
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                  width: Get.width * 0.6,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      ...ordersCtl.orders.map(
                        (order) {
                          return OrderHistoryTile(order);
                        },
                      ),
                    ]),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
