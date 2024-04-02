import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_editing_page.dart';

class ProfileStackWidget extends StatelessWidget {
  final String title;
  final bool isSettings;
  final IconData icon;
  const ProfileStackWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    ChatUser? myData;
    var height = context.height;
    var width = context.width;
    var profileCtr = Get.put(ProfilePageController());
    return StreamBuilder(
        stream: ChatService.getMyUserData(),
        initialData: profileCtr.currentUserData,
        builder: (context, snapshot) {
          myData = snapshot.data;

          if (myData != null && snapshot.hasData) {
            return Container(
              height: height * 0.23,
              width: width,
              padding: EdgeInsets.all(width * 0.036),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(myData!.image!))),
              child: Stack(
                children: [
                  Row(
                    children: [
                      CustomTextWidget(
                        text: title,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment(0, height * 0.0045),
                    child: myData?.image != null
                        ? CircleAvatar(
                            radius: width * 0.132,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4),
                            child: CircleAvatar(
                              radius: width * 0.13,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => ProfileEditingPage(
                                            chatUser: myData!,
                                          ),
                                      transition: Transition.downToUp);
                                },
                                child: CircleAvatar(
                                  radius: width * 0.12,
                                  backgroundImage: CachedNetworkImageProvider(
                                    myData!.image!,
                                  ),
                                  child: isSettings
                                      ? Align(
                                          alignment: Alignment(
                                              width * 0.003, -height * 0.0015),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: Icon(
                                              size: width * 0.05,
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                            ),
                          )
                        : CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
