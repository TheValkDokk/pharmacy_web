import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/constant.dart';
import '../../../models/drug.dart';
import '../../home/widgets/product_tile.dart';

class OtherDrugs extends StatelessWidget {
  const OtherDrugs(this.curDrug);
  final Drug curDrug;

  @override
  Widget build(BuildContext context) {
    var tempList = drugController.drugs;
    var list = [...tempList];
    list.removeWhere((element) => element == curDrug);
    list.shuffle();
    print(list.length);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: Get.height / Get.width * 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 10,
        itemBuilder: (_, i) => ProductTile(list[i]),
      ),
    );
  }
}
