import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/presrciption_service.dart';

class PrescriptionInput extends StatelessWidget {
  PrescriptionInput({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController addrCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              validator: (v) {
                if (GetUtils.isBlank(v.toString())!) {
                  return 'Please enter Patient\'s name';
                }
                return null;
              },
              controller: nameCtl,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                labelText: 'Patient\'s Name',
              ),
            ),
            TextFormField(
              validator: (v) {
                if (GetUtils.isBlank(v.toString())!) {
                  return 'Please enter your Address';
                }
                return null;
              },
              controller: addrCtl,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                labelText: 'Address',
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
              width: Get.width * 0.1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () {
                  PrescriptionService().uploadImg(
                    nameCtl.text,
                    addrCtl.text,
                  );
                },
                child: const Text('Send Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
