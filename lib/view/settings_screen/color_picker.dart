import 'package:doots/controller/settings_controller.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorPicker extends StatelessWidget {
  var colorController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    var width = context.width;

    return Row(
      children: [
        _buildColorAvatar(Colors.green),
        kWidth(width * 0.02),
        _buildColorAvatar(Colors.lightBlue),
        kWidth(width * 0.02),
        _buildColorAvatar(Colors.purple),
        kWidth(width * 0.02),
        _buildColorAvatar(Colors.pink),
        kWidth(width * 0.02),
        _buildColorAvatar(Colors.redAccent),
        kWidth(width * 0.02),
        _buildColorAvatar(Colors.grey),
      ],
    );
  }

  Widget _buildColorAvatar(Color color) {
    return GestureDetector(
      onTap: () {
        colorController.selectColor(color);
      },
      child: Obx(() {
        return CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: colorController.selectedColor.value == color
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : null,
        );
      }),
    );
  }
}
