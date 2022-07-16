import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constant/constant.dart';
import '../../../../models/order.dart';
import 'order_status_time_line.dart';

class DetailOrderPanel extends StatelessWidget {
  const DetailOrderPanel(this.order);
  final Order order;
  @override
  Widget build(BuildContext context) {
    final stream = db.collection('orders').doc(order.id).snapshots();
    var formatter = NumberFormat('#,###');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Order Date: ${DateFormat('dd MMMM, yyyy').format(order.date)}',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          'Price: ${formatter.format(order.price)},000 VND',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          'Items: ${order.listCart.length}',
          style: const TextStyle(fontSize: 20),
        ),
        const Text(
          'Your Order Status:',
          style: TextStyle(fontSize: 20),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final data = snap.data!.data()!;
              return Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: TimeLineOrder(data['status'])),
              );
            }
          },
          stream: stream,
        ),
        SizedBox(
          height: Get.height * 0.05,
          width: Get.width * 0.2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(), primary: Colors.red),
            onPressed: () {},
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
