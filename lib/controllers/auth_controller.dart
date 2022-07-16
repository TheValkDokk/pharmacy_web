import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/controllers/order_controller.dart';
import 'package:pharmacy_web/models/pharmacyUser.dart';

import '../constant/constant.dart';
import '../pages/login/login.dart';
import 'order_history_controller.dart';
import 'prescription_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool isLogged = false.obs;
  late Rx<User?> firebaseUser;
  Rx<PharmacyUser> pharmacyUser = PharmacyUser().obs;

  void checkSignin(Function func) {
    if (authController.isLogged.value) {
      func();
    } else {
      Get.snackbar(
        'You need to login to add this product to cart',
        '',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        messageText: ElevatedButton(
          onPressed: () => Get.toNamed(LoginPage.routeName),
          child: const Text('Log in'),
        ),
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, onUserChange);
  }

  Future onUserChange(User? user) async {
    if (user == null) {
      isLogged.value = false;
      disposeUserFunction();
    } else {
      initUserFunctions();
      sendUser();
      isLogged.value = true;
    }
  }

  void sendUser() {
    final u = firebaseUser.value!;
    final phone = u.phoneNumber ?? 0;
    var user = PharmacyUser(
        imgUrl: u.photoURL,
        mail: u.email,
        name: u.displayName,
        phone: phone.toString(),
        addr: 'user home');
    checkExist(user);
    // Get.put(UserActionoController());
  }

  Future<void> checkExist(PharmacyUser u) async {
    final userCollection = db.collection('users');
    await userCollection.doc(u.mail).get().then((doc) {
      if (doc.exists) {
        u = PharmacyUser.fromMap(doc.data() as Map<String, dynamic>);
        authController.pharmacyUser.value = u;
        currentOrderController.getOrder.user = u;
      } else {
        userCollection.doc(u.mail).set(u.toMap());
        authController.pharmacyUser.value = u;
        currentOrderController.getOrder.user = u;
      }
    });
  }

  Future disposeUserFunction() async {
    Get.delete<OrderController>();
    Get.delete<CurrentOrderController>();
    Get.delete<PreScripController>();
  }

  Future initUserFunctions() async {
    Get.put(OrderController());
    Get.put(CurrentOrderController());
    Get.put(PreScripController());
  }
}
