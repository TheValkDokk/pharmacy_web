import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

Future sendMsgChat(String idChat, String msg) async {
  try {
    Note note = Note(
      patient: FirebaseAuth.instance.currentUser!.email.toString(),
      msg: msg,
      time: DateTime.now(),
      mail: FirebaseAuth.instance.currentUser!.email.toString(),
      name: FirebaseAuth.instance.currentUser!.displayName.toString(),
    );
    await FirebaseFirestore.instance
        .collection('prescription')
        .doc(idChat)
        .collection('note')
        .add(
          note.toMap(),
        );
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

void toMain() => Get.toNamed('/');
