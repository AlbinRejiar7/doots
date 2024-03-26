import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAttachement1 extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int index;
  final void Function()? onPressed;
  const CustomAttachement1({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.index,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;

    return Column(
      children: [
        CircleAvatar(
            backgroundColor: color,
            child: IconButton(
              onPressed: onPressed,
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
