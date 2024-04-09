import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/constants/global.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/models/chat_items.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChattingScreenController extends GetxController {
  var otherChatUserData = ChatUser(groupIds: []).obs;
  Rx<String?> pinnedChatId = null.obs;
  late List<ChatItem> localChats;
  var data = GetStorage();
  var pinnedChats = <ChatItem>{}.obs;
  var archivedChats = <ChatItem>{}.obs;
  var allChats = <ChatItem>[];
  var foundedChatItem = <ChatItem>[].obs;
  var currentTapedChatUserId = ''.obs;
  var isGroupCreating = false.obs;
  List<ChatUser> contacts = [];
  Rx<ChatUser>? currentOtherChatUser = ChatUser().obs;
  late FocusNode focusNode;
  var scrollController = ScrollController();
  var canScrollToOldest = false.obs;
  TextEditingController nickNameCtr = TextEditingController();
  TextEditingController groupNameCtr = TextEditingController();
  TextEditingController descriptionCtr = TextEditingController();
  List<Message> chats = [];
  List<bool> isDeleted = [];
  void scrollToOldest() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  void fetchDataOfOtherUser(String otheruserId) async {
    DocumentSnapshot<Map<String, dynamic>> otherUserData =
        await ChatService.firestore.collection("users").doc(otheruserId).get();
    otherChatUserData.value = ChatUser.fromJson(otherUserData.data()!);
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

  void runFilter(String query) async {
    List<ChatItem> results = [];
    List<ChatItem> renamedChats = [];
    for (var chatItem in allChats) {
      if (chatItem.type == "user") {
        var data = await ChatService.getNicknameAsFuture(chatItem.id);
        String? nickName = data.data()?['nickName${chatItem.id}'];
        if (nickName != null) {
          final newChatItem = ChatItem(
            name: nickName,
            id: chatItem.id,
            type: chatItem.type,
            imageUrl: chatItem.imageUrl,
          );
          renamedChats.add(newChatItem);
        } else {
          // If nickName is null, use the original name
          renamedChats.add(chatItem);
        }
      } else {
        // If it's not of type "user", add the existing chatItem directly
        renamedChats.add(chatItem);
      }
    }

    if (query.isEmpty) {
      results = renamedChats;
    } else {
      results = renamedChats
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (results.isEmpty) {
        Fluttertoast.showToast(msg: "No results found for your query");
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

    if (authInstance.currentUser != null) {
      var pinnedChatsAsMap = data.read(ChatService.user.uid);
      var archivedChatsAsMap = data.read("archive${ChatService.user.uid}");
//to get pinned chats from local storage
      if (pinnedChatsAsMap != null) {
        List<ChatItem> pinnedChatAsModel = [
          ...pinnedChatsAsMap.map((map) => ChatItem.fromJson(map)),
        ];
        pinnedChats(pinnedChatAsModel.toSet());
      }
//to get archived chats from local storage
      if (archivedChatsAsMap != null) {
        List<ChatItem> archivedAsModel = [
          ...archivedChatsAsMap.map((map) => ChatItem.fromJson(map)),
        ];
        archivedChats(archivedAsModel.toSet());
      }
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
}
