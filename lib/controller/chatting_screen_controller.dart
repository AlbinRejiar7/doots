import 'package:doots/controller/audio_controller.dart';
import 'package:doots/models/chat_items.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChattingScreenController extends GetxController {
  Rx<String?> pinnedChatId = null.obs;
  late List<ChatItem> localChats;
  var data = GetStorage();
  var pinnedChats = <ChatItem>{}.obs;
  var allChats = <ChatItem>[];
  var foundedChatItem = <ChatItem>[].obs;
  var currentTapedChatUserId = ''.obs;
  var isGroupCreating = false.obs;
  List<ChatUser> contacts = [];
  late FocusNode focusNode;
  var scrollController = ScrollController();
  var canScrollToOldest = false.obs;
  TextEditingController groupNameCtr = TextEditingController();
  TextEditingController descriptionCtr = TextEditingController();
  List<Message> chats = [];
  void scrollToOldest() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  void scrollToLatest() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  // void pinChat(String chatId) {
  //   final index = foundedChatItem.indexWhere((chat) => chat.id == chatId);
  //   final pinnedChat = foundedChatItem.removeAt(index);
  //   foundedChatItem.insert(0, pinnedChat);

  // }

  void runfilter(String query) {
    List<ChatItem> results = [];

    if (query.isEmpty) {
      results = allChats;
    } else {
      results = allChats
          .where(
              (items) => items.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (results.isEmpty) {
        Fluttertoast.showToast(msg: "No Result found on your Query");
      }
    }

    foundedChatItem.value = results;
    update();
  }

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
  void selectedMessage(Message curretMessage) {
    chosenReplyMessage(curretMessage);

    update();
  }

  void isReplyWidgetOn(bool value) {
    isReply(value);
    update();
  }

  void changeBottomSheet(bool value) {
    isContainerVisibile(value);
  }

  void onScroll() {
    canScrollToOldest(scrollController.offset > 0.0);
  }

  TextEditingController chatCtr = TextEditingController();
  TextEditingController emojiCtr = TextEditingController();

  late AudioController audioC;
  @override
  void onInit() {
    super.onInit();

    foundedChatItem(allChats);

    // var pinnedChatsAsMap1 = data.read("pinnedchats");

    // if (pinnedChatsAsMap1 == null) {
    //   List<ChatItem> pinnedChatAsModel = [];
    //   pinnedChatAsModel = pinnedChatsAsMap1
    //       .cast<Map<String, dynamic>>()
    //       .map((map) => ChatItem.fromJson(map))
    //       .toList();
    //   pinnedChats(pinnedChatAsModel.toSet());
    // }

    var pinnedChatsAsMap = data.read("pinnedchats");

    if (pinnedChatsAsMap != null) {
      List<ChatItem> pinnedChatAsModel = [
        ...pinnedChatsAsMap.map((map) => ChatItem.fromJson(map)),
      ];
      pinnedChats(pinnedChatAsModel.toSet());
    }

    focusNode = FocusNode();
    audioC = Get.put(AudioController());
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  void changeEditingState() {
    isEditing(!isEditing.value);
  }

  void changeMicState(bool value) {
    isMic(value);
  }

  // Define a method to remove a chat from pinned chats in local storage
  void removeChatFromLocalStorage(String chatId) {
    List<Map<String, dynamic>> pinnedChats = data.read("pinnedchats") ?? [];

    // Remove the chat with the specified ID from the list

    // Update the local storage with the modified list
    data.write("pinnedchats", pinnedChats);
  }

// Call this method when you want to remove a chat from pinned chats in local storage
  void onRemoveChatFromLocalStorage(String chatId) {
    removeChatFromLocalStorage(chatId);
    // Optionally, update your UI or perform any other necessary tasks after removing the chat from local storage
  }
}
