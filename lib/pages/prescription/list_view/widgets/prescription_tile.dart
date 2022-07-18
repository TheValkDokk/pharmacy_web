import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/models/prescription.dart';

import '../../../../addons/image_viewer_popup.dart';

class PrescriptionHistoryTile extends StatelessWidget {
  const PrescriptionHistoryTile(this.pres);

  final Prescription pres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: Get.height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => imagePopUp(pres.imgurl),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: Get.width * 0.1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      pres.imgurl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: Get.width * 0.05),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                'Name: ${pres.name}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                'Status: ${pres.status}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                'Address: ${pres.addr}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {},
                child: AutoSizeText(
                  'Medicines: (${pres.medicines.length})',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
