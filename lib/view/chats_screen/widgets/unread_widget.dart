import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';

class UnReadCountWidget extends StatelessWidget {
  const UnReadCountWidget({
    super.key,
    required this.height,
    required this.unreadCount,
  });

  final double height;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.03,
      width: height * 0.03,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        color: kgreen1,
        child: Center(
          child: Text(
            unreadCount.toString(),
            style: TextStyle(color: kWhite, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
