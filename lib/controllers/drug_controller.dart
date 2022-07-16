import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/drug.dart';

class DrugController extends GetxController {
  static DrugController instance = Get.find();
  Rx<List<Drug>> drugList = Rx<List<Drug>>([]);

  List<Drug> get drugs => drugList.value;
  @override
  void onInit() {
    drugList.bindStream(DrugService().drugStream());
    super.onInit();
  }

  int getTotalPrice(List<String> drugId) {
    int total = 0;
    for (var id in drugId) {
      total += getDrug(id).price.toInt();
    }
    return total;
  }

  Drug getDrug(String id) {
    return drugs.firstWhere((element) => element.id == id);
  }
}

class DrugService {
  final CollectionReference _drug =
      FirebaseFirestore.instance.collection('drugs');

  Stream<List<Drug>> drugStream() {
    return _drug.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final f = Drug.fromMap(doc.data() as dynamic);
          return f;
        }).toList());
  }
}
