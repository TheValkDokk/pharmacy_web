import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/prescription.dart';
import '../../../../services/global.dart';
import 'dialog_chat.dart';

class PrescriptionDetailChat extends StatelessWidget {
  const PrescriptionDetailChat(this.pres);

  final Prescription pres;

  @override
  Widget build(BuildContext context) {
    var textCtl = TextEditingController();
    final bool isSupport = pres.status != 'FINISH';
    return Column(
      children: [
        Expanded(child: DialogChat(pres.id)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white38,
              borderRadius: BorderRadius.circular(25),
            ),
            height: Get.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.start,
                    enabled: isSupport,
                    controller: textCtl,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 10),
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: isSupport
                          ? 'Type your message here'
                          : 'Support for this prescription has ended',
                    ),
                    maxLength: 250,
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue, size: 30),
                  onPressed: () {
                    if (!isSupport) {
                      Get.snackbar('You can not send message',
                          'This Presciption support has ended',
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else if (textCtl.text.trim().isEmpty) {
                      Get.snackbar('Type Something',
                          'You need to type something in chat',
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else {
                      sendMsgChat(pres.id, textCtl.text.trim());
                      textCtl.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
