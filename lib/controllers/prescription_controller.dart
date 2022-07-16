import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/prescription.dart';

class PreScripController extends GetxController {
  static PreScripController instance = Get.find();
  Rx<List<Prescription>> prescList = Rx<List<Prescription>>([]);

  List<Prescription> get prescriptions => prescList.value;

  @override
  void onInit() {
    prescList.bindStream(PrescriptionSerivce().preScriptStream());
    super.onInit();
  }
}

class PrescriptionSerivce {
  final CollectionReference _prescription =
      FirebaseFirestore.instance.collection('prescription');

  Stream<List<Prescription>> preScriptStream() {
    return _prescription.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final f = Prescription.fromMap(doc.data() as dynamic);
          return f;
        }).toList());
  }
}
