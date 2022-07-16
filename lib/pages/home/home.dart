import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/category.dart';
import '../../models/drug.dart';
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
            _textGuidance('Category'),
            _buildCategory(),
            _textGuidance('Today Recommendation'),
            _buildRecommend(),
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('drugs').snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var list = snapshot.data!.docs;
            print(list.length);

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
        }));
  }
}
