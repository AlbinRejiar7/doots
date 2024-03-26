import 'package:doots/controller/home_screen_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/bottomnavbuilder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(HomeScreenController());
    Get.put(ProfilePageController());

    return Obx(() {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () {
          ChatService.updateActiveStatus(false);
          return Future.value(true);
        },
        child: Scaffold(
            body: c.bottomPages[c.currentIndex.value],
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: c.currentIndex.value,
              onTap: (index) {
                c.onTapBottomBar(index);
              },
            )),
      );
    });
  }
}
