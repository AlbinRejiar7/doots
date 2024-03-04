import 'package:doots/controller/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'bottom_sheet_controller/icons.dart';

class ChattingScreenController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final scrollController = ScrollController();
  var emojiShowing = false.obs;
  var isEditing = false.obs;
  var isMic = true.obs;
  var isContainerVisibile = false.obs;
  void changeBottomSheet(bool value) {
    isContainerVisibile(value);
  }

  TextEditingController chatCtr = TextEditingController();
  TextEditingController emojiCtr = TextEditingController();
  var chats = RxList([]);

  late AudioController audioC;
  @override
  void onInit() {
    super.onInit();
    audioC = Get.put(AudioController());
  }

  void addchat(var chat, MessageType messageType,
      {String? fileName,
      String? extension,
      String? size,
      String? thumbnail}) async {
    if (messageType == MessageType.audio) {
      chats.add({
        "chats": chat,
        "type": messageType,
      });
    } else if (messageType == MessageType.document) {
      chats.add({
        "chats": chat,
        "type": messageType,
        "fileName": fileName ?? '',
        "extension": extension ?? '',
        "size": size ?? " ",
      });
    } else if (messageType == MessageType.photos) {
      chats.add({
        "chats": chat,
        "type": messageType,
        "size": size ?? " ",
        "id": const Uuid().v4(),
      });
    } else if (messageType == MessageType.videos) {
      var Thumbnails = [thumbnail];
      List reVThumbnail = [];
      reVThumbnail.addAll(Thumbnails.reversed);

      chats.add({
        "chats": chat,
        "type": messageType,
        "size": size ?? " ",
        "thumbnail": reVThumbnail
      });
    } else {
      chats.add({
        "chats": chat,
        "type": messageType,
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
