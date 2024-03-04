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
        color: kGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.add,
          size: 14,
          color: kWhite,
        ),
      ),
    ),
  );
}
