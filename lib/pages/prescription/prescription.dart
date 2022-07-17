import 'package:flutter/material.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

import 'widgets/image_picker_upload.dart';
import 'widgets/prescription_information_input.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: Center(child: ImagePickerUpload())),
            Expanded(child: Center(child: PrescriptionInput())),
            // PrescriptionInfo(),
          ],
        ),
      ),
    );
  }
}
