import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

GestureDetector photoBox(height, Message message) {
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
              image: CachedNetworkImageProvider(message.msg))),
    ),
  );
}
