import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreenController extends GetxController {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  List contacts = [
    'Boby',
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eva',
    'Frank',
    'Grace',
    'Hank',
    'Albin',
    'Ivy',
    'Aleena',
    'Jack',
    'Kelly',
    'Liam',
    'Mia',
    'Noah',
    'Olivia',
    'Penny',
    'Quinn',
    'Ryan',
    'Sophia',
    'Tom',
    'Uma',
    'Violet',
    'Will',
    'Xander',
    'Yara',
    'Zoe',
  ];

  void addNamesTolist(String name) {
    foundedUsers.add(name);
  }

  RxList<dynamic> foundedUsers = RxList<dynamic>([]);
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
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    foundedUsers.value = results;
  }
}
