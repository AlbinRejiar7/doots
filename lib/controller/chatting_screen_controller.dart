import 'package:doots/controller/audio_controller.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingScreenController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final scrollController = ScrollController();
  var emojiShowing = false.obs;
  var isEditing = false.obs;
  var isMic = true.obs;

  TextEditingController chatCtr = TextEditingController();
  TextEditingController emojiCtr = TextEditingController();
  RxList chats = RxList([]);
  RxList voicechats = RxList([]);
  var audioC = Get.put(AudioController());
  void addchat(
    String chat,
    MessageType type,
  ) async {
    if (type == MessageType.audio) {
      var totalDuration = await audioC.player.setFilePath(
        chat,
      );
      audioC.player.stop();
      chats.add({"chats": chat, "type": type, "duration": totalDuration});
    } else {
      chats.add({
        "chats": chat,
        "type": type,
      });
    }
  }

  void changeEmojiState() {
    emojiShowing(!emojiShowing.value);
  }

  void changeEditingState() {
    isEditing(!isEditing.value);
  }

  void changeMicState(bool value) {
    isMic(value);
  }
}
