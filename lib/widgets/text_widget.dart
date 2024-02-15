import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final Paint? foreground;
  final Paint? background;
  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.decoration,
    this.foreground,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          background: background,
          foreground: foreground,
          decoration: decoration,
          overflow: TextOverflow.ellipsis,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight),
    );
  }
}
