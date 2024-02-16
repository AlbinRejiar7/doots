import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAttachement extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int index;

  const CustomAttachement({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var documentCtr = Get.put(DocumentController());

    return Column(
      children: [
        CircleAvatar(
            backgroundColor: color,
            child: IconButton(
              onPressed: () async {
                if (index == 0) {
                  await documentCtr.pickDocument();
                }
              },
              icon: Icon(
                icon,
                color: kgreen1,
                size: 17,
              ),
            )),
        kHeight(height * 0.01),
        FittedBox(
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 11),
          ),
        )
      ],
    );
  }
}
