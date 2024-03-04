import 'dart:io';

import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';

Column audioDocBubble(
    double width,
    Future<File> convertFileToFutureFile(String filePath),
    List<dynamic> chats,
    int index,
    BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Container(
          padding: EdgeInsets.all(width * 0.02),
          alignment: Alignment.centerRight,
          child: VoiceMessage(
              meBgColor: kgreen1,
              played: false,
              audioFile: convertFileToFutureFile(chats[index]["chats"]),
              me: true)),
      Padding(
        padding: EdgeInsets.only(right: width * 0.02),
        child: Text(DateFormat.jm().format(DateTime.now()),
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
      ),
    ],
  );
}
