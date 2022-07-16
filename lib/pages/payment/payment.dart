import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_web/services/order_service.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../constant/constant.dart';
import 'widgets/payment_tile.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Obx(() {
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: currentOrderController.cartCount <= 0
                      ? const Center(
                          child: Text(
                            'Your Cart is empty',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : const PaymentPanel(),
                ),
                const Expanded(
                  flex: 2,
                  child: PaymentTotal(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class PaymentPanel extends StatelessWidget {
  const PaymentPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currentOrderController.cartCount.value,
      itemBuilder: (context, index) {
        return PaymentTile(index);
      },
    );
  }
}

class PaymentTotal extends StatelessWidget {
  const PaymentTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameCtl = TextEditingController();
    TextEditingController phoneCtl = TextEditingController();
    TextEditingController addrCtl = TextEditingController();
    int paymentMethod = 1;
    var pharmaUser = authController.pharmacyUser.value;
    nameCtl.text = pharmaUser.name.toString();
    phoneCtl.text = pharmaUser.phone.toString();
    addrCtl.text = pharmaUser.addr.toString();
    var formatter = NumberFormat('#,###');
    final formKey = GlobalKey<FormState>();
    return Column(
      children: [
        SizedBox(
          width: Get.width * 0.2,
          height: Get.height * 0.8,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  validator: (v) {
                    String value = v.toString().trim();
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    labelText: 'Full Name',
                  ),
                  controller: nameCtl,
                ),
                TextFormField(
                  validator: (v) {
                    if (!v!.isPhoneNumber) {
                      return 'Please enter Phone Number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    labelText: 'Phone Number',
                  ),
                  controller: phoneCtl,
                ),
                TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) return 'Please enter address';
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                    labelText: 'Address',
                  ),
                  controller: addrCtl,
                ),
                Column(
                  children: [
                    const AutoSizeText(
                      'Payment Method',
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ToggleSwitch(
                        customWidths: [
                          Get.width * 0.04,
                          Get.width * 0.07,
                          Get.width * 0.04,
                          Get.width * 0.04,
                        ],
                        minHeight: 50,
                        initialLabelIndex: 1,
                        cornerRadius: 20.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 4,
                        labels: const [
                          'Momo',
                          'Cash on Delivery',
                          'Zalo Pay',
                          'Bank'
                        ],
                        activeBgColors: const [
                          [Colors.pink],
                          [Colors.green],
                          [Colors.blue],
                          [Colors.deepPurple],
                        ],
                        onToggle: (index) {
                          paymentMethod = index!.toInt();
                        },
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return AutoSizeText(
                    'Total Price: ${formatter.format(currentOrderController.cartPrice.value)},000 VND',
                    style: const TextStyle(fontSize: 20),
                  );
                }),
                SizedBox(
                  width: Get.width * 0.2,
                  height: Get.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Get.defaultDialog(
                          title: 'Confirm and Place Order?',
                          content: const Text('Are you sure to place order?'),
                          cancel: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Check My Order Again'),
                          ),
                          confirm: ElevatedButton(
                            onPressed: () {
                              currentOrderController.getOrder.user.name =
                                  nameCtl.text;
                              currentOrderController.getOrder.user.phone =
                                  phoneCtl.text;
                              currentOrderController.getOrder.user.addr =
                                  addrCtl.text;

                              currentOrderController.getOrder.method =
                                  paymentMed(paymentMethod);
                              OrderService().placeOrder();
                              OrderService().updateUserInfo();
                              Get.defaultDialog(
                                  title: "Order Processed",
                                  content: const Text(
                                    "Your order is processed and will be delivered soon",
                                  ),
                                  confirm: TextButton(
                                    onPressed: () => Get.offAllNamed('/'),
                                    child: const Text('OK'),
                                  ));
                            },
                            child: const Text("Place My Order"),
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "Invaild field",
                          "Please check your information again!",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String paymentMed(int i) {
    switch (i) {
      case 0:
        return 'Momo';
      case 1:
        return 'Cash on Delivery';
      case 2:
        return 'Zalo Pay';
      case 3:
        return 'Bank';
      default:
        return 'Cash on Delivery';
    }
  }
}
