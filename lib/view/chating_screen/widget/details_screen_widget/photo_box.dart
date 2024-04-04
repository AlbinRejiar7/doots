import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

Widget photoBox(height, Message message) {
  try {
    return GestureDetector(
      onTap: () {
        Get.to(() =>
            PhotoView(imageProvider: CachedNetworkImageProvider(message.msg)));
      },
      child: Container(
        height: height * 0.2,
        width: height * 0.2,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  message.msg,
                  errorListener: (error) {
                    log(error.toString());
                  },
                ))),
      ),
    );
  } on Exception catch (e) {
    print("Error loading image: $e");
    return Container();
  }
}
