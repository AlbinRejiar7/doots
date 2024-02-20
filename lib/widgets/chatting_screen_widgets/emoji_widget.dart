import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiWidget extends StatelessWidget {
  var c = Get.put(ChattingScreenController());
  EmojiWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Obx(() {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: c.emojiShowing.value ? height * 0.35 : 0,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            c.changeMicState(false);
          },
          textEditingController: c.chatCtr,
          config: Config(
            checkPlatformCompatibility: true,
          ),
        ),
      );
    });
  }
}
