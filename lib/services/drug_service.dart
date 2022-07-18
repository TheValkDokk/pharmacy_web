import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant/constant.dart';
import '../models/drug.dart';

class DrugService {
  final CollectionReference _drug =
      FirebaseFirestore.instance.collection('drugs');

  Stream<List<Drug>> drugStream() {
    return _drug.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final f = Drug.fromMap(doc.data() as dynamic);
          return f;
        }).toList());
  }

  Drug getDrug(String id) {
    final drugs = drugController.drugs;
    for (var i = 0; i < drugs.length; i++) {
      if (drugs[i].id == id) {
        return drugs[i];
      }
    }
    return drugs[0];
  }
}
