import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/view/chating_screen/widget/details_screen_widget/build_box.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/color_constants.dart';

Builder audioBox(
    DocumentController docCtr, bool isUser, Message message, height) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.audiotrack_sharp,
                color: kgreen1,
              ),
              Text(message.duration)
            ],
          ),
        ));
  });
}
