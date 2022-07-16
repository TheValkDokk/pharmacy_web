import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nil/nil.dart';

import '../../../constant/constant.dart';

class PaymentTile extends StatefulWidget {
  const PaymentTile(this.index);

  final int index;

  @override
  State<PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<PaymentTile> {
  final TextEditingController _quanCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    if (currentOrderController.getOrder.listCart[widget.index].quantity == 0) {
      return nil;
    }
    var formatter = NumberFormat('#,###');
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      )),
      padding: const EdgeInsets.all(5),
      child: Obx(() {
        final cart = currentOrderController.getOrder.listCart[widget.index];
        _quanCtl.text = cart.quantity.toString();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                cart.drug.imgUrl,
                height: Get.height * 0.1,
              ),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(
                cart.drug.fullName,
                maxLines: 3,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Expanded(
              flex: 1,
              child: SelectableText(
                '${formatter.format(cart.drug.price)},000 VND',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        padding: const EdgeInsets.all(0),
                        onPressed: () => setState(() {
                              currentOrderController.decCart(cart.drug);
                            }),
                        icon: const Icon(Icons.remove)),
                    Flexible(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _quanCtl,
                          validator: (v) {
                            if (GetUtils.isNumericOnly(v.toString()) &&
                                int.parse(v.toString()) > 0 &&
                                int.parse(v.toString()) <= 30) {
                              return null;
                            } else {
                              //dangerous snackbar
                              Get.snackbar(
                                  'Error', 'Quantity must be between 1 and 30',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return 'Error';
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              currentOrderController.setCart(
                                  cart.drug, int.parse(_quanCtl.text));
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${cart.quantity}',
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    IconButton(
                        color: Colors.blue,
                        onPressed: () => setState(() {
                              currentOrderController.incCart(cart.drug);
                            }),
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SelectableText(
                '  ${cart.drug.unit}',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Expanded(
              flex: 1,
              child: SelectableText(
                '${formatter.format(cart.price)},000 VND',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentOrderController.confirmRemove(widget.index);
              }),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        );
      }),
    );
  }
}
