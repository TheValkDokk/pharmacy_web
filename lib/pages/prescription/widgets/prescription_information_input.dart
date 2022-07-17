import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../../../constant/constant.dart';
import '../../../models/note.dart';
import '../../../models/prescription.dart';

class PrescriptionInput extends StatelessWidget {
  PrescriptionInput({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController addrCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              validator: (v) {
                if (GetUtils.isBlank(v.toString())!) {
                  return 'Please enter Patient\'s name';
                }
                return null;
              },
              controller: nameCtl,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                labelText: 'Patient\'s Name',
              ),
            ),
            TextFormField(
              validator: (v) {
                if (GetUtils.isBlank(v.toString())!) {
                  return 'Please enter your Address';
                }
                return null;
              },
              controller: addrCtl,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                labelText: 'Address',
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
              width: Get.width * 0.1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () {
                  uploadImg(
                    nameCtl.text,
                    addrCtl.text,
                  );
                },
                child: const Text('Send Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadImg(String name, String addr) async {
    String uname = authController.firebaseUser.value!.displayName.toString();
    String umail = authController.firebaseUser.value!.email.toString();
    SendPresciprClass(appController.imgValue).myAsyncMethod((value) {
      final prescrip = Prescription(
        id: '1',
        name: name,
        addr: addr,
        mail: umail,
        imgurl: value,
        medicines: [],
        status: 'pending',
        createAt: DateTime.now(),
      );
      if (value.length > 10) {
        uploadPrescipInfo(prescrip);
        Get.offAllNamed('/');
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Prescription sent successfully',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        );
      }
    });
  }

  Future uploadPrescipInfo(Prescription prescrip) async {
    await db.collection('prescription').add(prescrip.toMap()).then((value) {
      prescrip.id = value.id;
      db.collection('prescription').doc(value.id).update(prescrip.toMap());
    });
    Note note = Note(
        patient: prescrip.mail,
        name: FirebaseAuth.instance.currentUser!.displayName.toString(),
        msg: 'Posted a Drug Prescription',
        time: DateTime.now(),
        mail: FirebaseAuth.instance.currentUser!.email.toString());
    await db.collection('prescription').doc(prescrip.id).collection('note').add(
          note.toMap(),
        );
  }
}

class SendPresciprClass {
  SendPresciprClass(this.xfile);

  final XFile? xfile;

  Future<void> myAsyncMethod(Function onSuccess) async {
    UploadTask? uploadTask;
    appController.progress = 0;
    try {
      // showLoading("Uploading, Please wait...");
      Get.defaultDialog(
        title: 'Uploading',
        content: Obx(() {
          return SizedBox(
            height: Get.height * 0.3,
            width: Get.width * 0.5,
            child: LiquidLinearProgressIndicator(
              value: appController.progress, // Defaults to 0.5.
              valueColor: const AlwaysStoppedAnimation(
                  Colors.blue), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors
                  .white, // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.blue,
              borderWidth: 5.0,
              borderRadius: 12.0,
              direction: Axis
                  .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
              center: const Text("Loading..."),
            ),
          );
          // return Text('Uploading, ${appController.progress}');
        }),
      );
      final path = 'prescription/${xfile!.name}';
      final send = FirebaseStorage.instance.ref().child(path);

      uploadTask = send.putData(
        await xfile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      uploadTask.snapshotEvents.listen((event) {
        appController.progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        if (event.state == TaskState.success) {}
      }).onError((error) {
        // do something to handle error
      });
      final snapshot = await uploadTask.whenComplete(() {});
      String url = await snapshot.ref.getDownloadURL();
      if (url.length > 10) {
        onSuccess(url);
      }
    } catch (e) {
      log(e.toString());
      Get.defaultDialog(
        title: 'Alert',
        content: const Text('Please select or take the Drug\'s Presription'),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
      );
    }
  }
}
