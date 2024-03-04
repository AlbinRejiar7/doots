import 'package:doots/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDropdownButton extends StatelessWidget {
  const MyDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsController());
    var width = context.width;
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).primaryColor,
            ),
            child: DropdownButton<String>(
              underline: const SizedBox(),
              value: controller.selectedValue.value,
              onChanged: (String? newValue) {
                controller.selectedValue.value = newValue!;
              },
              items: <String>['Everyone', 'Nobody'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
