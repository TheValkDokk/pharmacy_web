import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/note.dart';
import '../models/pharmacyUser.dart';

Future<PharmacyUser> getUserByMail(String mail) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(mail)
      .get()
      .then(
    (value) {
      PharmacyUser user =
          PharmacyUser.fromMap(value.data() as Map<String, dynamic>);
      return user;
    },
  );
}

void sendMsgChat(String idChat, String msg) {
  try {
    FirebaseFirestore.instance.collection('prescription').doc(idChat).update({
      "note":
          FieldValue.arrayUnion([Note(msg: msg, time: DateTime.now()).toMap()])
    });
  } on Exception catch (e) {
    print(e);
  }
}

void addToCart(String id, String idDrug) {
  try {
    FirebaseFirestore.instance.collection('prescription').doc(id).update({
      "medicines": FieldValue.arrayUnion([idDrug])
    });
  } on Exception catch (e) {
    print(e);
  }
}

void removeFromCart(String id, String idDrug) {
  try {
    FirebaseFirestore.instance.collection('prescription').doc(id).update({
      "medicines": FieldValue.arrayRemove([idDrug])
    });
  } on Exception catch (e) {
    print(e);
  }
}

void toMain() {
  Get.toNamed('/');
}
