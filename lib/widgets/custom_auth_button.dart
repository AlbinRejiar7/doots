import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  const CustomAuthButton({
    super.key,
    required this.title,
    this.onTap,
    this.color = kgreen1,
    this.textColor = kWhite,
  });

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Center(
            child: CustomTextWidget(
          fontWeight: FontWeight.w800,
          text: title,
          color: textColor,
        )),
      ),
    );
  }
}
