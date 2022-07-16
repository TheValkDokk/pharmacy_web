import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_web/models/drug.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../constant/constant.dart';
import '../../icons/icon.dart';

class DrugDetail extends StatelessWidget {
  const DrugDetail(this._drug);

  final Drug _drug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      height: Get.height * 0.4,
                      memCacheWidth: 487,
                      memCacheHeight: 300,
                      imageUrl: _drug.imgUrl,
                      placeholder: (_, url) =>
                          const Center(child: Icon(MyFlutterApp.capsules)),
                      errorWidget: (_, url, er) => Lottie.asset(
                        'assets/json-gif/image-loading.json',
                        alignment: Alignment.center,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          AutoSizeText(
                            _drug.fullName,
                            style: GoogleFonts.kanit(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PriceAndAddWidget(drug: _drug),
                              const ShippingMethod(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceAndAddWidget extends StatelessWidget {
  const PriceAndAddWidget({
    Key? key,
    required Drug drug,
  })  : _drug = drug,
        super(key: key);

  final Drug _drug;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          AutoSizeText(
            "${_drug.price.toStringAsFixed(3)} VND / ${_drug.unit}",
            style: GoogleFonts.kanit(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: Get.height * 0.05,
            width: Get.width * 0.18,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () => authController.checkSignin(addToCart),
                icon: const Icon(Icons.add_shopping_cart_sharp),
                label: const Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 25),
                )),
          )
        ],
      ),
    );
  }

  void addToCart() => currentOrderController.addToCart(_drug);
}

class ShippingMethod extends StatelessWidget {
  const ShippingMethod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: Get.width * 0.85,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Shipping Method: Pickup, Delivery \nFree Shipping for Order above 300,000 VND',
                style: GoogleFonts.kanit(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: Get.width * 0.85,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Delivery Service Provider:',
                    style: GoogleFonts.kanit(fontSize: 18),
                  ),
                  Wrap(
                    runSpacing: 10,
                    spacing: 15,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFE66020),
                            shape: const StadiumBorder()),
                        child: const Text("Giao Hang Nhanh"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFE2492B),
                            shape: const StadiumBorder()),
                        child: const Text("Shoppe"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF152348),
                            shape: const StadiumBorder()),
                        child: const Text("Ahamove"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF03AA4D),
                            shape: const StadiumBorder()),
                        child: const Text("Grab"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFEFAE11),
                            shape: const StadiumBorder()),
                        child: const Text("Be"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
