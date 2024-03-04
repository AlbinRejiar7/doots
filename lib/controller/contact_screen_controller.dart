import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreenController extends GetxController {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  var currentIndex = 0.obs;

  RxList<dynamic> foundedUsers = <dynamic>[].obs;
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

  List<Map<String, dynamic>> contacts = [
    {'name': 'Boby', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Alice', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Bob', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Charlie', 'isFav': false.obs, 'isChecked': false},
    {'name': 'David', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Eva', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Frank', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Grace', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Hank', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Albin', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Ivy', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Aleena', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Jack', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Kelly', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Liam', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Mia', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Noah', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Olivia', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Penny', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Quinn', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Ryan', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Sophia', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Tom', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Uma', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Violet', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Will', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Xander', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Yara', 'isFav': false.obs, 'isChecked': false},
    {'name': 'Zoe', 'isFav': false.obs, 'isChecked': false},
  ];

  void updateIsFav() {
    foundedUsers[currentIndex.value]
        ['isFav'](!foundedUsers[currentIndex.value]['isFav'].value);
    update();
  }

  void tappedIndex(int index) {
    currentIndex(index);
  }

  void addNamesTolist(String name) {
    foundedUsers.add({'name': name, 'isFav': false.obs, 'isChecked': false});
  }

  @override
  void onInit() {
    super.onInit();
    foundedUsers.value = contacts;
  }

  void runfilter(String query) {
    List results = [];
    if (query.isEmpty) {
      results = contacts;
    } else {
      results = contacts
          .where((user) =>
              user['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    foundedUsers.value = results;
  }

  void changeIsCheckedState(int index) {
    foundedUsers[index]['isChecked'] = !foundedUsers[index]['isChecked'];
    update();
  }
}
