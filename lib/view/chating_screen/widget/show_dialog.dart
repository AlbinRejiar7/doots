import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> showDialogeWidget({
  required BuildContext context,
  required void Function()? onPressedTick,
  required String title,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        TextButton(onPressed: onPressedTick, child: Text("Yes")),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No"))
      ],
    ),
  );
}
