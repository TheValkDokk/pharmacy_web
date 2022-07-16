import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_web/pages/order_detail/order_detail.dart';
import 'package:pharmacy_web/pages/payment/payment.dart';
import '../pages/home/home.dart';

class PageViewController extends GetxController {
  static PageViewController instance = Get.find();
  final Rx<int> pageIndex = 0.obs;

  Widget getScreenWidget() {
    switch (pageIndex.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const OrderHistoryList();
      case 2:
        return const OrderHistoryList();
      case 3:
        return const PaymentPage();
      default:
        return const HomeScreen();
    }
  }
}
