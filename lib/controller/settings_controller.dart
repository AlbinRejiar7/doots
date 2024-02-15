import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var selectedStatus = 'Active'.obs;
  RxString selectedValue = 'Everyone'.obs;
  Rx<Color> selectedColor = Rx<Color>(Colors.green);
  void changeState(String value) {
    selectedStatus(value);
  }

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  void changeStatusDp(String newValue) {
    selectedValue(newValue);
  }
}
