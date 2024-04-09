import 'dart:developer';

import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/widget/media_widgets/build_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaGridViewWidget extends StatelessWidget {
  const MediaGridViewWidget({
    super.key,
    required this.isFullScreen,
  });
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ChattingScreenController());
    var docCtr = Get.put(DocumentController());
    var height = context.height;
    var width = context.width;
    c.chats.forEach((element) {
      log(element.msg);
    });
    final List<Message> mediaChats = c.chats
        .where(
            (chat) => chat.messageType != "text" && !(chat.isDeleted ?? false))
        .toList();

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: height * 0.02,
          crossAxisSpacing: width * 0.02),
      itemCount: isFullScreen
          ? mediaChats.length
          : mediaChats.length > 12
              ? 12
              : mediaChats.length,
      itemBuilder: (BuildContext context, int index) {
        bool isUser = (mediaChats[index].fromId == ChatService.user.uid);
        return buildMessageWidget(
            mediaChats[index], height, width, docCtr, isUser);
      },
    );
  }
}
