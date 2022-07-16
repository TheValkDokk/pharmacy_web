import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../models/category.dart';
import '../../models/drug.dart';
import '../drug_detail/drug_detail.dart';
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
            _buildads2(),
            _textGuidance('Category'),
            _buildCategory(),
            _textGuidance('Today Recommendation'),
            _buildRecommend(),
            _buildads1(),
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
          stream: FirebaseFirestore.instance.collection('drugs').snapshots(),
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

  Widget _buildads1() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          final d = drugController.drugs.firstWhere((element) =>
              element.fullName == 'Peptide Collagen Essence Mask (23g)');
          Get.to(() => DrugDetail(d));
        },
        child: Image.asset('assets/images/imaBanner.webp'),
      ),
    );
  }

  Widget _buildads2() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          final d = drugController.drugs.firstWhere((element) =>
              element.fullName ==
              'Brauer Liquid Multivitamin With Iron syrup for children 200ml bottle');
          Get.to(() => DrugDetail(d));
        },
        // child: Image.asset('/assets/images/imgBanner4.png'),
        child: Image.network(
            'https://cdn.tgdd.vn/2022/07/banner/592.182-592x182-1.png'),
      ),
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
