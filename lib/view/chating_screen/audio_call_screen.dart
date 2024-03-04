import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallingScreen extends StatelessWidget {
  const AudioCallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Contact Name",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "0:10",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: width * 0.07),
            ),
          ),
          kHeight(height * 0.26),
          CircleAvatar(
            backgroundImage: const NetworkImage(
                "https://i.pinimg.com/474x/98/51/1e/98511ee98a1930b8938e42caf0904d2d.jpg"),
            radius: width * 0.2,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
            color: kDarkModeBlack,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.05),
                topRight: Radius.circular(width * 0.05))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.speaker,
                color: kWhite,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.video_chat,
                color: kWhite,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.mic_off,
                color: kWhite,
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {},
              icon: const Icon(
                Icons.call_end,
                color: kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
