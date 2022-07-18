import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/constant/constant.dart';

import '../../models/category.dart';
import '../../models/drug.dart';
import '../ads/ads.dart';
import 'widgets/btnGroup.dart';
import 'widgets/product_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            buildads2(),
            _textGuidance('Category'),
            _buildCategory(),
            _textGuidance('Today Recommendation'),
            _buildRecommend(),
            buildads1(),
            _textGuidance('Medicines'),
            _buildList('A1'),
            _textGuidance('Medical Equipment'),
            _buildList('A2'),
          ],
        ),
      ),
    );
  }

  Align _textGuidance(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonDrug(iconList[0]),
          ButtonDrug(iconList[1]),
          ButtonDrug(iconList[2]),
          ButtonDrug(iconList[3]),
        ],
      ),
    );
  }

  Widget _buildRecommend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection('drugs').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var list = snapshot.data!.docs;
              list.shuffle();
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: Get.height / Get.width * 1.5,
                  crossAxisSpacing: 20,
                ),
                itemCount: 5,
                itemBuilder: (_, i) {
                  var drug = Drug.fromMap(list[i].data());
                  return ProductTile(drug);
                },
              );
            }
          })),
    );
  }

  Widget _buildList(String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('drugs').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var list = snapshot.data!.docs;
              list.removeWhere((element) => element.data()['type'] != type);
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: Get.height / Get.width * 1.5,
                  crossAxisSpacing: 20,
                ),
                itemCount: 5,
                itemBuilder: (_, i) {
                  var drug = Drug.fromMap(list[i].data());
                  return ProductTile(drug);
                },
              );
            }
          })),
    );
  }
}
