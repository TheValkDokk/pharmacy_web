import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../constant/constant.dart';
import '../../models/drug.dart';
import '../home/widgets/product_tile.dart';

class LoadMoreScreen extends StatelessWidget {
  const LoadMoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = Get.parameters['type'].toString();
    print(type.toString());
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db
                    .collection('drugs')
                    .where('type', isEqualTo: type)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var list = snapshot.data!.docs;
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 40,
                        childAspectRatio: Get.height / Get.width * 1.5,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        var drug = Drug.fromMap(list[i].data());
                        return ProductTile(drug);
                      },
                    );
                  }
                })),
          ),
        ),
      ),
    );
  }
}
