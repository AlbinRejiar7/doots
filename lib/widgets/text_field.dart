import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Widget? suffixIcon;
  final bool obscureText;
  final String hintText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color? fillColor;
  final bool? filled;
  final bool isBoarder;
  int? maxLines = 1;
  final bool? isMaxLine;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextStyle? style;
  final Widget? prefix;
  final bool isChattingScreen;

  CustomTextField({
    super.key,
    required this.hintText,
    this.focusNode,
    this.validator,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.fillColor,
    this.filled,
    this.isBoarder = true,
    this.onChanged,
    this.maxLines,
    this.isMaxLine = false,
    this.onTap,
    this.style,
    this.prefix,
    this.isChattingScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      onTap: onTap,
      maxLines: isMaxLine! ? maxLines : 1,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      decoration: InputDecoration(
          prefixIcon: prefix,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: isChattingScreen
                  ? BorderSide.none
                  : BorderSide(color: kgreen1, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  isChattingScreen ? BorderSide.none : BorderSide(width: 0.3)),
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          fillColor: fillColor,
          filled: filled,
          suffixIcon: suffixIcon,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(10),
          isCollapsed: true,
          isDense: true,
          border: isBoarder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                )
              : const OutlineInputBorder(borderSide: BorderSide.none)),
    );
  }
}
