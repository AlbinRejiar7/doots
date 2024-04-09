import 'package:doots/view/call_screen/call_screen.dart';
import 'package:doots/view/chats_screen/chats_screen.dart';
import 'package:doots/view/contacts_screen/contacts_screen.dart';
import 'package:doots/view/profile_screen/profile_screen.dart';
import 'package:doots/view/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreenController extends GetxController {
  final data = GetStorage();
  @override
  void onInit() {
    super.onInit();
    isdarkmode(data.read('theme') ?? false);
  }

  List bottomPages = [
    const ChatsScreen(),
    const ContactsScreen(),
    const CallsScreen(),
    const SizedBox(),
    const ProfileScreen(),
    const SettingScreen(),
  ];
  var currentIndex = 0.obs;
  var isdarkmode = false.obs;

  void changeTheme() async {
    isdarkmode(!isdarkmode.value);
    await data.write('theme', isdarkmode.value);
  }

  void onTapBottomBar(int index) {
    if (index == 3) isdarkmode(!isdarkmode.value);

    currentIndex(index);
  }
}
