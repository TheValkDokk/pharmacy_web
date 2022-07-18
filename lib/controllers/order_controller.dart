import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_web/constant/constant.dart';
import 'package:pharmacy_web/models/cart.dart';
import 'package:pharmacy_web/models/drug.dart';
import 'package:pharmacy_web/models/order.dart';
import 'package:pharmacy_web/models/pharmacyUser.dart';

class CurrentOrderController extends GetxController {
  static CurrentOrderController instance = Get.find();
  var formatter = NumberFormat('#,###');
  RxInt cartCount = 0.obs;
  RxDouble cartPrice = 0.0.obs;

  Rx<Order> order = Order(
    listCart: [],
    user: PharmacyUser(),
    status: 'NewOrder',
    date: DateTime.now(),
    id: 'id',
    method: 'Cash',
    price: 0,
  ).obs;

  @override
  void onReady() {
    super.onReady();
    order.value.user = authController.pharmacyUser.value;
  }

  Order get getOrder => order.value;

  void addBulk(List<Drug> drug) {
    for (var e in drug) {
      addToCart(e);
    }
  }

  void addToCart(Drug drug) {
    if (isSmaller30(drug)) {
      addOrInc(drug);
      getOrder.price = updatePrice(getOrder.listCart);
      cartCount.value = getOrder.listCart.length;
      cartPrice.value = getOrder.price.toDouble();
      Get.closeAllSnackbars();
      Get.snackbar(
        "Item Added",
        "Total Price: ${formatter.format(cartPrice.value)},000 VND with ${cartCount.value} items",
        colorText: Colors.white,
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Item at max quantity",
        "You can only buy 30 items at max",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  //bool check if drug quantity in cart is above 30
  bool isSmaller30(Drug drug) {
    int i = getOrder.listCart.indexWhere((cart) => cart.drug.id == drug.id);
    if (i == -1) {
      return true;
    } else {
      if (getOrder.listCart[i].quantity < 30) {
        return true;
      } else {
        return false;
      }
    }
  }

  void addOrInc(Drug drug) {
    int i = getOrder.listCart.indexWhere((cart) => cart.drug.id == drug.id);
    if (i == -1) {
      getOrder.listCart.add(Cart(drug: drug, price: drug.price, quantity: 1));
    } else {
      getOrder.listCart[i].quantity++;
    }
  }

  num updatePrice(List<Cart> carts) {
    num price = 0;
    for (var cart in carts) {
      price += cart.drug.price * cart.quantity;
      cart.price = cart.drug.price * cart.quantity;
    }
    return price;
  }

  //remove from cart use index
  void removeFromCart(int index) {
    getOrder.listCart.removeAt(index);
    getOrder.price = updatePrice(getOrder.listCart);
    cartCount.value = getOrder.listCart.length;
    cartPrice.value = getOrder.price.toDouble();
  }

  //clear cart
  void clearCart() {
    getOrder.listCart.clear();
    getOrder.price = 0;
    cartCount.value = 0;
  }

  //clear cart with dialog
  void confirmClearCart() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Your Cart?'),
        content: const Text('Are you sure to wipe your cart?'),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text('Remove'),
            onPressed: () {
              clearCart();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  //widget dialog to confirm remove from cart
  void confirmRemove(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure to remove this item from cart?'),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text('Remove'),
            onPressed: () {
              removeFromCart(index);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  //increase cart quantity
  void incCart(Drug drug) {
    int i = getOrder.listCart.indexWhere((cart) => cart.drug.id == drug.id);
    if (i != -1) {
      getOrder.listCart[i].quantity++;
    }
    getOrder.price = updatePrice(getOrder.listCart);
    cartCount.value = getOrder.listCart.length;
    cartPrice.value = getOrder.price.toDouble();
  }

  //decrease cart quantity remove if quantity = 0
  void decCart(Drug drug) {
    int i = getOrder.listCart.indexWhere((cart) => cart.drug.id == drug.id);
    if (i != -1) {
      if (getOrder.listCart[i].quantity > 1) {
        getOrder.listCart[i].quantity--;
      } else {
        confirmRemove(i);
      }
    }
    getOrder.price = updatePrice(getOrder.listCart);
    cartCount.value = getOrder.listCart.length;
    cartPrice.value = getOrder.price.toDouble();
  }

  //set cart quantity
  void setCart(Drug drug, int quantity) {
    int i = getOrder.listCart.indexWhere((cart) => cart.drug.id == drug.id);
    if (i != -1) {
      getOrder.listCart[i].quantity = quantity;
    }
    getOrder.price = updatePrice(getOrder.listCart);
    cartCount.value = getOrder.listCart.length;
    cartPrice.value = getOrder.price.toDouble();
  }
}
