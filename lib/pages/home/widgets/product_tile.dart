import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_web/widgets/on_hover_fly.dart';

import '../../../constant/constant.dart';
import '../../../icons/icon.dart';
import '../../../models/drug.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(this._drug);

  final Drug _drug;

  @override
  Widget build(BuildContext context) {
    double containerWidth = 300;

    return OnHoverFly(
      onTap: () {
        Get.toNamed('/details/${_drug.id}');
      },
      child: Container(
        width: containerWidth,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      height: Get.height * 0.2,
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.green,
                          ),
                        ),
                        TextSpan(
                          text: " ${_drug.rating.toStringAsFixed(1)}",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: AutoSizeText(
                _drug.title,
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            const Spacer(),
            AutoSizeText(
              "${_drug.price.toStringAsFixed(3)} VND / ${_drug.unit}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: Get.height * 0.08,
              width: containerWidth,
              child: ElevatedButton.icon(
                onPressed: () => authController.checkSignin(addToCart),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart_sharp),
                label: const Text(
                  "Add to cart",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart() => currentOrderController.addToCart(_drug);
}
