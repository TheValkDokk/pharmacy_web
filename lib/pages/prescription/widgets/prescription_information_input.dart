import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      Note note = Note(
        patient: umail,
        msg: 'Posted a Drug Prescription',
        time: DateTime.now(),
        mail: umail,
        name: uname,
      );
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
        Get.back();
        // Get.to(() => const PaymentCompleteScreen('pre'));
      }
    });
  }

  Future<void> uploadPrescipInfo(Prescription prescrip) async {
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
    try {
      Get.defaultDialog(
        title: "Uploading, Please wait...",
        content: const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final file = File(xfile!.path);
      final path = 'prescription/${xfile!.name}';
      log('send file: $path');
      final send = FirebaseStorage.instance.ref().child(path);
      log('upload 1');
      uploadTask = send.putData(
        await xfile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      log('upload 2');
      final snapshot = await uploadTask.whenComplete(() {});
      String url = await snapshot.ref.getDownloadURL();
      print('url: $url');
      onSuccess(url);
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
