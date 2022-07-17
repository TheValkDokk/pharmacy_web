import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/constant.dart';

class ImagePickerUpload extends StatelessWidget {
  const ImagePickerUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              pickImage();
            },
            onLongPress: () {
              if (appController.imgValue != null) {
                Get.defaultDialog(
                  title: 'Prescription Image',
                  content: SizedBox(
                    height: Get.height * 0.6,
                    width: Get.height * 0.6,
                    child: InteractiveViewer(
                      child: Image.network(appController.imgValue!.path),
                    ),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              height: Get.height * 0.5,
              width: Get.height * 0.5,
              child: appController.imgValue != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(appController.imgValue!.path),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_search_rounded,
                            size: Get.height * 0.1,
                          ),
                          const Text('Click here to select an Image'),
                        ],
                      ),
                    ),
            ),
          ),
          if (appController.imgValue != null)
            const Text(
              'Click to select another Image, Long press to view the current Image',
              style: TextStyle(fontSize: 18),
            ),
          const Text(
            'We will contact you after we receive the presciption',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;
      appController.imgValue = image;
    } catch (e) {
      log(e.toString());
    }
  }
}
