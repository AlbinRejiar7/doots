import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PhotoBubble extends StatelessWidget {
  const PhotoBubble({
    super.key,
    required this.chats,
    required this.height,
    required this.width,
    required this.index,
  });

  final List chats;
  final double height;
  final double width;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(
              () => PhotoViewer(
                initialIndex: index,
                tag: 'hero-tag-$index',
                files: chats[index]['chats'],
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerRight,
                height: height * 0.3,
                margin: EdgeInsets.only(left: width * 0.48),
                child: Hero(
                    tag: 'hero-tag-$index',
                    child: Container(
                      decoration: BoxDecoration(
                          color: kgreen1.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(chats[index]['chats'][index]))),
                    )),
              ),
              Text(DateFormat.jm().format(DateTime.now()),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 12)),
            ],
          ),
        ));
  }
}
