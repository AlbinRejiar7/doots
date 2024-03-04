import 'package:doots/controller/home_screen_controller.dart';
import 'package:doots/widgets/bottomnavbuilder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(HomeScreenController());

    return Obx(() {
      return Scaffold(
          body: c.bottomPages[c.currentIndex.value],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: c.currentIndex.value,
            onTap: (index) {
              c.onTapBottomBar(index);
            },
          ));
    });
  }
}
