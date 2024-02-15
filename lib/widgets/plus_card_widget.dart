import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';

SizedBox plusCardButton(
  double height,
  void Function()? onTap,
) {
  return SizedBox(
    height: height * 0.055,
    width: height * 0.055,
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: kGreen.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Icon(
          Icons.add,
          size: 14,
          color: kGreen,
        ),
      ),
    ),
  );
}
