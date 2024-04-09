import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/view/chating_screen/widget/media_widgets/build_box.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/color_constants.dart';

Builder videoBox(
    bool isUser, Message message, DocumentController docCtr, height) {
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
        child: Container(
          height: height * 0.2,
          width: height * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(message.thumbnailPath))),
          child: Icon(
            Icons.play_circle_filled_sharp,
            color: kgreen1,
          ),
        ));
  });
}
