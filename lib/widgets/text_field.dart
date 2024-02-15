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
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(5),
                )
              : OutlineInputBorder(borderSide: BorderSide.none)),
    );
  }
}
