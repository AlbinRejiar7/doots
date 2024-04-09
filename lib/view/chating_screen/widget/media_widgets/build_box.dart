import 'dart:developer';

import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/view/chating_screen/widget/media_widgets/photo_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import 'audio_box.dart';
import 'doc_box.dart';
import 'video_box.dart';

Widget buildMessageWidget(Message message, var height, var width,
    DocumentController docCtr, bool isUser) {
  log(message.msg);
  switch (message.messageType) {
    case 'image':
      return photoBox(height, message);
    case 'document':
      return docBox(isUser, message, docCtr, width, height);
    case 'video':
      return videoBox(isUser, message, docCtr, height);
    case 'audio':
      return audioBox(docCtr, isUser, message, height);
    default:
      return const SizedBox();
  }
}

void onTap(
    {required GetStorage data,
    required String filePath,
    required bool isUser,
    required Message message,
    required DocumentController docCtr}) {
  if (isUser) {
    filePath = message.localFileLocation;
  } else {
    if (message.isDownloaded) {
      filePath = data.read(message.filename) as String;
    } else {
      Fluttertoast.showToast(msg: "Please Download the Doc");
    }
  }
  docCtr.openFile(filePath);
}
