import 'package:doots/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreenController extends GetxController {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  RxList<ChatUser> selectedMembers = <ChatUser>[].obs;
  var noResultsFound = false.obs;
  var currentChatUserId = ''.obs;

  RxList<ChatUser> firebaseContacts = <ChatUser>[].obs;

  void addFirebaseContactsTolist(List<ChatUser> users) {
    firebaseContacts(users);
  }

  void addFirebaseContacts(List<ChatUser> users) {
    firebaseContacts.forEach((e) {
      firebaseContacts.addAllIf(!firebaseContacts.contains(e), users);
    });
  }

  RxList<ChatUser> foundedUsers = <ChatUser>[].obs;
  List title = [
    [
      'MESSAGE',
      Icons.chat,
    ],
    [
      "FAVOURITE",
      Icons.favorite_border,
    ],
    [
      "AUDIO",
      Icons.call,
    ],
    [
      "VIDEO",
      Icons.video_camera_back_rounded,
    ],
    [
      "ARCHIVE",
      Icons.archive_rounded,
    ],
    [
      "MUTED",
      Icons.mic_off_outlined,
    ],
    ["DELETE", Icons.delete_outlined],
  ];

  // void updateIsFav() {
  //   foundedUsers[currentIndex.value]
  //       ['isFav'](!foundedUsers[currentIndex.value]['isFav'].value);
  //   update();
  // }
  @override
  void onInit() {
    super.onInit();
    foundedUsers(firebaseContacts);
  }

  // void tappedIndex(int index) {
  //   currentIndex(index);
  // }

  void runfilter(String query) {
    List<ChatUser> results = [];

    if (query.isEmpty) {
      results = firebaseContacts;
      noResultsFound.value = false;
    } else {
      results = firebaseContacts
          .where(
              (user) => user.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      noResultsFound.value = results.isEmpty;
    }

    foundedUsers.value = results;
    update();
  }
}
