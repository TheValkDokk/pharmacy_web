import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_web/controllers/auth_controller.dart';

import '../controllers/app_controller.dart';
import '../controllers/drug_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/order_history_controller.dart';
import '../controllers/prescription_controller.dart';

class Const {
  static const String appVersion = "1.0.0";
  static const String title = "Pharmacy"; //App Name
  static const String logo = "assets/images/logo.png"; //App Logo

  static const String titleTag = 'app_title';
  static const String logoTag = 'app_logo';
}

DrugController drugController = DrugController.instance;
AppController appController = AppController.instance;
OrderController orderController = OrderController.instance;
PreScripController preController = PreScripController.instance;
AuthController authController = AuthController.instance;
CurrentOrderController currentOrderController = CurrentOrderController.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;
