import 'package:flutter/material.dart';
import 'package:get/get.dart';

void imagePopUp(String url) {
  Get.defaultDialog(
    title: 'Prescription Image',
    content: InteractiveViewer(
      child: Image.network(
        height: Get.height * 0.7,
        width: Get.height * 0.7,
        url,
        fit: BoxFit.cover,
      ),
    ),
  );
}
