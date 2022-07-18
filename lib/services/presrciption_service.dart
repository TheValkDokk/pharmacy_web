import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pharmacy_web/services/drug_service.dart';

import '../constant/constant.dart';
import '../models/drug.dart';
import '../models/note.dart';
import '../models/prescription.dart';

class PrescriptionService {
  Stream<List<Prescription>> getMyPrescriptionStream() {
    final mail = authController.firebaseUser.value!.email.toString();

    return db
        .collection('prescription')
        .where('mail', isEqualTo: mail)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Prescription.fromMap(doc.data()))
            .toList());
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

  Stream<List<Drug>> getRecommendDrug(String id) {
    return db.collection('prescription').doc(id).snapshots().map((event) {
      final Prescription pres =
          Prescription.fromMap(event.data() as Map<String, dynamic>);
      List<Drug> list = [];
      for (var e in pres.medicines) {
        list.add(DrugService().getDrug(e));
      }
      return list;
    });
  }

  Future uploadImg(String name, String addr) async {
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
            height: Get.height * 0.15,
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
              center: const Text("Uploading..."),
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
