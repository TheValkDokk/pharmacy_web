import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

class OrderHistoryTile extends StatelessWidget {
  const OrderHistoryTile(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy, hh:mm a').format(order.date);
    var formatter = NumberFormat('#,###');
    return InkWell(
      onTap: () {
        Get.toNamed('/orderDetail', arguments: order);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Order Date: $date',
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      'Price: ${formatter.format(order.price)},000 VND',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      'Payment Method: ${order.method}',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      'Items: ${order.listCart.length}',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      'Status: ${order.status}',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.listCart.length >= 2 ? 2 : 1,
              itemBuilder: (context, i) {
                return SizedBox(
                  height: Get.height * 0.1,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    leading: SizedBox(
                      width: Get.width * 0.1,
                      child: CachedNetworkImage(
                        height: Get.height * 0.2,
                        memCacheHeight: 1000,
                        imageUrl: order.listCart[i].drug.imgUrl,
                        placeholder: (_, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (_, url, er) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    title: Text(
                      order.listCart[i].drug.fullName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(letterSpacing: 1, fontSize: 20),
                    ),
                    subtitle: Text(
                      '${order.listCart[i].price.toStringAsFixed(3)} - ${order.listCart[i].quantity} ${order.listCart[i].drug.unit}',
                      style: const TextStyle(letterSpacing: 1, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            if (order.listCart.length > 2)
              Text(
                '${order.listCart.length - 2} more',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              )
          ],
        ),
      ),
    );
  }
}
