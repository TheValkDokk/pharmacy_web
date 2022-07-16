import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

Widget buildads1() {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        final d = drugController.drugs.firstWhere((element) =>
            element.fullName == 'Peptide Collagen Essence Mask (23g)');
        Get.toNamed('/details/${d.id}');
      },
      child: Image.asset('assets/images/imaBanner.webp'),
    ),
  );
}

Widget buildads2() {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        final d = drugController.drugs.firstWhere((element) =>
            element.fullName ==
            'Brauer Liquid Multivitamin With Iron syrup for children 200ml bottle');
        Get.toNamed('/details/${d.id}');
      },
      // child: Image.asset('/assets/images/imgBanner4.png'),
      child: Image.network(
          'https://cdn.tgdd.vn/2022/07/banner/592.182-592x182-1.png'),
    ),
  );
}
