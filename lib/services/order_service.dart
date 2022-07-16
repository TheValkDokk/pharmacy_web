import 'package:pharmacy_web/constant/constant.dart';

class OrderService {
  Future placeOrder() async {
    var order = currentOrderController.getOrder;
    await db.collection('orders').add(order.toMap()).then((value) {
      order.id = value.id;
      db.collection('orders').doc(value.id).update(order.toMap());
    });
  }

  Future updateUserInfo() async {
    var user = currentOrderController.getOrder.user;
    await db.collection('users').doc(user.mail).update(user.toMap());
  }
}
