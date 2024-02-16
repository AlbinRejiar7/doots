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
  var chats = RxList([]);

  late AudioController audioC;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    audioC = Get.put(AudioController());
  }

  void addchat(String chat, MessageType type,
      {String? fileName, String? extension}) async {
    if (type == MessageType.audio) {
      chats.add({
        "chats": chat,
        "type": type,
      });
    } else if (type == MessageType.document) {
      chats.add({
        "chats": chat,
        "type": type,
        "fileName": fileName ?? 'null',
        "extension": extension ?? ''
      });
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
