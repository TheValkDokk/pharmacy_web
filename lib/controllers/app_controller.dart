import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  Rx<XFile?> imgFile = Rx<XFile?>(null);
  XFile? get imgValue => imgFile.value;
  set imgValue(XFile? f) => imgFile.value = f;
}
