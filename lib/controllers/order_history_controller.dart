import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/order.dart';

class OrderController extends GetxController {
  static OrderController instance = Get.find();
  Rx<List<Order>> orderList = Rx<List<Order>>([]);

  List<Order> get orders => orderList.value;

  @override
  void onInit() {
    orderList.bindStream(OrderService().orderStream());
    super.onInit();
  }
}

class OrderService {
  final CollectionReference _order =
      FirebaseFirestore.instance.collection('orders');

  Stream<List<Order>> orderStream() {
    return _order.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final f = Order.fromMap(doc.data() as dynamic);
          return f;
        }).toList());
  }

  Future orderStatus(String st, String id) async {
    await _order.doc(id).update({'status': st});
  }
}
