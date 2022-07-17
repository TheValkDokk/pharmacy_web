import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading(String str) {
  Get.defaultDialog(
    title: str == '' ? 'Loading...' : str,
    content: const Center(child: CircularProgressIndicator.adaptive()),
    barrierDismissible: false,
  );
}

dissmissLoading() => Get.back();
