import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/profile_screen/profile_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    ChatUser? myData;
    var profileCtr = Get.put(ProfilePageController());
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: ChatService.getMyUserData(),
            initialData: profileCtr.currentUserData,
            builder: (context, snapshot) {
              myData = snapshot.data;
              if (myData != null && snapshot.hasData) {
                return Column(
                  children: [
                    ProfileStackWidget(
                      title: 'My Profile',
                      icon: Icons.more_vert,
                    ),
                    kHeight(height * 0.08),
                    Text(myData!.name ?? "loading...",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7))),
                    Text("developer",
                        style: Theme.of(context).textTheme.bodyLarge),
                    Divider(
                      thickness: 0.2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(myData!.about ?? "Loading...",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          kHeight(height * 0.05),
                          Row(
                            children: [
                              Icon(Icons.person_outline),
                              kWidth(width * 0.04),
                              Text(myData!.name ?? "loading...",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          kHeight(height * 0.05),
                          Row(
                            children: [
                              Icon(Icons.chat_rounded),
                              kWidth(width * 0.04),
                              Text(myData!.email ?? "loading...",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          kHeight(height * 0.05),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              kWidth(width * 0.04),
                              Text(myData!.location ?? "loading...",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          kHeight(height * 0.05),
                          Divider(
                            thickness: 0.2,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.fromSize();
              }
            }),
      ),
    );
  }
}
