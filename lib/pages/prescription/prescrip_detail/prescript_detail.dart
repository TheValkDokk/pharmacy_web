import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pharmacy_web/addons/image_viewer_popup.dart';
import 'package:pharmacy_web/constant/constant.dart';
import 'package:pharmacy_web/models/prescription.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../../models/drug.dart';
import '../../../services/presrciption_service.dart';
import '../../cart/cart_window.dart';
import 'widgets/drug_rec_tile.dart';
import 'widgets/prescription_chat.dart';

class PrescriptionHistoryDetail extends StatelessWidget {
  const PrescriptionHistoryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Prescription pres = Get.arguments as Prescription;
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Row(
            children: [
              Expanded(child: PrescriptionDetailPanel(pres)),
              Expanded(child: PrescriptionDetailChat(pres)),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionDetailPanel extends StatelessWidget {
  const PrescriptionDetailPanel(this.pres);
  final Prescription pres;
  @override
  Widget build(BuildContext context) {
    List<Drug> drugList = [];
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: GestureDetector(
              onTap: () => imagePopUp(pres.imgurl),
              child: Image.network(
                pres.imgurl,
                width: Get.width * 0.4,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<List<Drug>>(
              stream: PrescriptionService().getRecommendDrug(pres.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.blue, size: 40),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Recommend Drug'),
                  );
                } else {
                  drugList = snapshot.data!;
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: drugList.length,
                    itemBuilder: (context, index) {
                      return DrugRecTile(drugList[index]);
                    },
                  );
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(
                height: Get.height * 0.05,
                child: ElevatedButton(
                  onPressed: () => createOrder(drugList),
                  child: const Text('Create Order'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void createOrder(List<Drug> drugs) {
    if (currentOrderController.cartCount.value != 0) {
      Get.defaultDialog(
        title: 'You have another order in progress',
        content: const Text(
          'You have others items in your cart. \nEither remove them or finish the order.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: Colors.blue,
            ),
            onPressed: () {
              Get.defaultDialog(
                title: 'Cart',
                content: const CartWindow(),
              );
            },
            child: const Text('View Current Cart'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: Colors.red,
            ),
            onPressed: () {
              processRecMed(drugs);
            },
            child: const Text('Remove Current Cart And Procress Order'),
          ),
        ],
      );
    } else {
      processRecMed(drugs);
    }
  }

  void processRecMed(List<Drug> drugs) {
    currentOrderController.addBulk(drugs);
    Get.defaultDialog(
      title: 'Cart',
      content: const CartWindow(),
    );
  }
}
