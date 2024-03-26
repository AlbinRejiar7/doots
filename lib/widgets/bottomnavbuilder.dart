import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/auth_controller.dart';
import 'package:doots/controller/home_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/auth/choose_page.dart';
import 'package:doots/view/change_password/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var c = Get.put(HomeScreenController());
    var authCtr = Get.put(AuthController());
    return Container(
      height: height * 0.08,
      width: width,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/images/icons/chatsicon.png', context),
          _buildNavItem(1, 'assets/images/icons/contacts.png', context),
          _buildNavItem(2, 'assets/images/icons/callicon.png', context),
          Obx(() {
            return InkWell(
              onTap: () {
                c.changeTheme();
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        c.isdarkmode.value
                            ? 'assets/images/icons/moon.png'
                            : 'assets/images/icons/sun.png',
                        color: 3 == currentIndex
                            ? kLightGreen.withGreen(255)
                            : Colors.grey,
                        scale: 1.1,
                      ),
                    ],
                  ),
                  if (3 == currentIndex && 3 != 3 && 3 != 4)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: kLightGreen.withGreen(255),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 0) {
                  c.onTapBottomBar(4);
                } else if (value == 1) {
                  c.onTapBottomBar(5);
                } else if (value == 2) {
                  Get.to(() => const ChangePasswordScreen());
                } else if (value == 3) {
                  await authCtr.signOut().then((value) {
                    Get.snackbar("Log out", 'Successfull');
                    Get.offAll(() => const ChoosingPage());
                  });
                }
              },
              color: Theme.of(context).primaryColor,
              surfaceTintColor: Colors.transparent,
              offset: Offset((width * 0.5), -(height * 0.33)),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              Icons.person_3_outlined,
                              size: 16,
                            )
                          ],
                        )),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Settings",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              Icons.settings_outlined,
                              size: 16,
                            )
                          ],
                        )),
                    PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Change password",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              Icons.lock_open_rounded,
                              size: 16,
                            )
                          ],
                        )),
                    PopupMenuItem<int>(
                        value: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Log out",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              Icons.logout_rounded,
                              size: 16,
                            )
                          ],
                        )),
                    PopupMenuItem<int>(
                        value: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delete account",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              Icons.person_3_outlined,
                              size: 16,
                            )
                          ],
                        )),
                  ],
              child: StreamBuilder(
                stream: ChatService.getMyUserData(),
                builder: (context, snapshot) {
                  final myData = snapshot.data;
                  if (myData != null) {
                    return CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage:
                            CachedNetworkImageProvider(myData.image!));
                  } else {
                    return CircularProgressIndicator(
                      strokeWidth: 2,
                    );
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, var image, BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                color: index == currentIndex
                    ? Theme.of(context).colorScheme.onSecondary
                    : Colors.grey,
                scale: 1.1,
              ),
            ],
          ),
          if (index == currentIndex && index != 3 && index != 4)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
