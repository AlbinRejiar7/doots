import 'package:doots/controller/audio_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingScreenController extends GetxController {
  var currentIndex = 0.obs;
  late FocusNode focusNode;
  final scrollController = ScrollController();
  TextEditingController groupNameCtr = TextEditingController();
  TextEditingController descriptionCtr = TextEditingController();
  List<Message> chats = [];

  // var emojiShowing = false.obs;
  Rx<Message> chosenReplyMessage = Message(
          replyMessage: '',
          toId: '',
          msg: '',
          read: '',
          messageType: '',
          fromId: '',
          sent: '',
          ext: '',
          size: '',
          filename: '',
          localFileLocation: '',
          thumbnailPath: '',
          localThumbnailPath: '',
          duration: '')
      .obs;

  var isEditing = false.obs;
  var isMic = true.obs;
  var isReply = false.obs;
  var isContainerVisibile = false.obs;
  // var isTyping = false.obs;
  void selectedMessage(Message curretMessage) {
    chosenReplyMessage(curretMessage);

    update();
  }

  void isReplyWidgetOn(bool value) {
    isReply(value);
    update();
  }

  // void changeIsTypingState(bool value) {
  //   isTyping(value);
  // }

  void changeBottomSheet(bool value) {
    isContainerVisibile(value);
  }

  TextEditingController chatCtr = TextEditingController();
  TextEditingController emojiCtr = TextEditingController();

  late AudioController audioC;
  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    audioC = Get.put(AudioController());
  }

  // void addchat(var chat, MessageType messageType,
  //     {String? fileName,
  //     String? extension,
  //     String? size,
  //     String? thumbnail}) async {
  //   if (messageType == MessageType.audio) {
  //     chats.add({
  //       "chats": chat,
  //       "type": messageType,
  //     });
  //   } else if (messageType == MessageType.document) {
  //     chats.add({
  //       "chats": chat,
  //       "type": messageType,
  //       "fileName": fileName ?? '',
  //       "extension": extension ?? '',
  //       "size": size ?? " ",
  //     });
  //   } else if (messageType == MessageType.photos) {
  //     chats.add({
  //       "chats": chat,
  //       "type": messageType,
  //       "size": size ?? " ",
  //       "id": const Uuid().v4(),
  //     });
  //   } else if (messageType == MessageType.videos) {
  //     var Thumbnails = [thumbnail];
  //     List reVThumbnail = [];
  //     reVThumbnail.addAll(Thumbnails.reversed);

  //     chats.add({
  //       "chats": chat,
  //       "type": messageType,
  //       "size": size ?? " ",
  //       "thumbnail": reVThumbnail
  //     });
  //   } else {
  //     chats.add({
  //       "chats": chat,
  //       "type": messageType,
  //     });
  //   }
  // }

  // void changeEmojiState() {
  //   emojiShowing(!emojiShowing.value);
  // }

  void changeEditingState() {
    isEditing(!isEditing.value);
  }

  void changeMicState(bool value) {
    isMic(value);
  }
}
