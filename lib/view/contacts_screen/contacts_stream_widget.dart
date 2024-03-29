import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactsStreamBuilder extends StatelessWidget {
  const ContactsStreamBuilder({
    super.key,
    required this.c,
    required this.height,
    required this.width,
    this.isSelectingForgroups = false,
  });

  final ContactScreenController c;
  final double height;
  final double width;
  final bool isSelectingForgroups;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ChatService.getContactsId(),
        builder: (context, snapshot) {
          if (snapshot.data?.docs.isNotEmpty ?? false) {
            return StreamBuilder(
              stream: ChatService.getAllUsers(
                  snapshot.data?.docs.map((e) => e.id).toList() ?? []),
              builder: (context, snapshot) {
                var data = snapshot.data?.docs;
                c.addFirebaseContactsTolist(
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        []);

                return GetBuilder<ContactScreenController>(builder: (_) {
                  return Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: ListView.builder(
                      itemCount: c.foundedUsers.length,
                      itemBuilder: (context, index) {
                        c.firebaseContacts.sort((a, b) {
                          return a.name!
                              .toLowerCase()
                              .compareTo(b.name!.toLowerCase());
                        });
                        if (index == 0 ||
                            c.foundedUsers[index].name![0] !=
                                c.foundedUsers[index - 1].name![0]) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomTextWidget(
                                    text: c.foundedUsers[index].name![0],
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  kWidth(width * 0.02),
                                  const Expanded(
                                      child: Divider(
                                    thickness: 0,
                                  )),
                                ],
                              ),
                              ListTile(
                                onTap: () async {
                                  if (isSelectingForgroups) {
                                    if (!c.selectedMembers
                                        .contains(c.foundedUsers[index])) {
                                      c.selectedMembers
                                          .add(c.foundedUsers[index]);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Already Selected this Member");
                                    }
                                  } else {
                                    Get.to(
                                      () => ChattingScreen(
                                        chatUser: c.firebaseContacts[index],
                                      ),
                                    );
                                  }
                                },
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      c.foundedUsers[index].image!),
                                ),
                                title: Text(c.foundedUsers[index].name!),
                                // trailing: IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(
                                //       Icons.more_vert,
                                //       color: kGreen,
                                //     )),
                              ),
                            ],
                          );
                        } else {
                          return ListTile(
                            onTap: () async {
                              if (isSelectingForgroups) {
                                if (!c.selectedMembers
                                    .contains(c.foundedUsers[index])) {
                                  c.selectedMembers.add(c.foundedUsers[index]);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Already Selected this Member");
                                }
                              } else {
                                Get.to(
                                  () => ChattingScreen(
                                    chatUser: c.firebaseContacts[index],
                                  ),
                                );
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  c.foundedUsers[index].image!),
                            ),
                            title: Text(c.foundedUsers[index].name!),
                            // trailing: IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(
                            //       Icons.more_vert,
                            //       color: kGreen,
                            //     )),
                          );
                        }
                      },
                    ),
                  ));
                });
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
