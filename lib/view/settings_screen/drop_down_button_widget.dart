import 'package:doots/controller/settings_controller.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusDropdown extends StatelessWidget {
  const StatusDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(SettingsController());

    return Obx(() {
      return DropdownButton<String>(
        dropdownColor: Theme.of(context).primaryColor,
        value: c.selectedStatus.value,
        onChanged: (newValue) {
          c.changeState(newValue!);
        },
        items: <String>['Active', 'Away', 'DND']
            .map<DropdownMenuItem<String>>((String value) {
          Color color =
              _getColor(value); // Function to get color based on status
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: color,
                ),
                kWidth(10),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }).toList(),
        underline: const SizedBox(),
      );
    });
  }

  Color _getColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Away':
        return Colors.orange;
      case 'DND':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
