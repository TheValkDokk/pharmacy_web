import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import '../../../models/prescription.dart';
import '../../../services/presrciption_service.dart';
import 'widgets/prescription_tile.dart';

class PrescriptionListScreen extends StatelessWidget {
  const PrescriptionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: PreScriptHistoryPanel(),
    );
  }
}

class PreScriptHistoryPanel extends StatelessWidget {
  const PreScriptHistoryPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: Get.width * 0.8,
          child: StreamBuilder<List<Prescription>>(
            stream: PrescriptionService().getMyPrescriptionStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final pres = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: pres.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        '/prescriptionHistoryDetail',
                        arguments: pres[index],
                      ),
                      child: PrescriptionHistoryTile(pres[index]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
