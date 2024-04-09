import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/view/chating_screen/widget/media_widgets/build_box.dart';
import 'package:doots/widgets/chatting_screen_widgets/document_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Builder docBox(
    bool isUser, Message message, DocumentController docCtr, width, height) {
  return Builder(builder: (context) {
    var data = GetStorage();
    var filePath = '';

    return GestureDetector(
      onTap: () => onTap(
          data: data,
          docCtr: docCtr,
          filePath: filePath,
          isUser: isUser,
          message: message),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: width * 0.1,
              height: height * 0.075,
              child: DocIcon(height: height)),
          Text(
            message.filename,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  });
}
