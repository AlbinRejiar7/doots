import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoginScreen = false.obs;
  var isChecked = false.obs;
  void changeAuthScreen() {
    isLoginScreen(!isLoginScreen.value);
  }

  void changeCheckBox(bool value) {
    isChecked(value);
  }
}
