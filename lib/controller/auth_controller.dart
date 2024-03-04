import 'package:get/get.dart';

class AuthController extends GetxController {
  var isChecked = false.obs;

  void changeCheckBox(bool value) {
    isChecked(value);
  }
}
