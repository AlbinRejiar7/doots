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
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextStyle? style;
  final Widget? prefix;
  final bool isChattingScreen;
  final void Function(String?)? onSaved;
  final String? labelText;
  final TextInputType? keyboardType;
  const CustomTextField({
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
    this.onTap,
    this.style,
    this.prefix,
    this.isChattingScreen = false,
    this.onSaved,
    this.labelText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : 5,
      minLines: 1,
      onSaved: onSaved,
      style: style,
      onTap: onTap,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          labelText: labelText,
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
