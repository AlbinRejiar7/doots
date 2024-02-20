import 'dart:io';

import 'package:doots/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoBubble extends StatelessWidget {
  const VideoBubble({
    super.key,
    required this.chats,
    required this.width,
    required this.height,
    required this.index,
  });

  final List chats;
  final double width;
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    int lengthThumbnail = chats[index]['thumbnail'].length;

    return GestureDetector(
        onTap: () {
          Get.to(
              () => VideoGallery(
                  initialIndex: index, videoFiles: chats[index]['chats']),
              transition: Transition.cupertino);
        },
        child: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Container(
            padding: EdgeInsets.all(width * 0.02),
            height: height * .4,
            margin: EdgeInsets.only(left: width * 0.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                    image: FileImage(
                        File(chats[index]['thumbnail'][lengthThumbnail - 1])))),
            child: Icon(
              Icons.play_circle_filled_outlined,
              size: width * 0.12,
            ),
          ),
        ));
  }
}
