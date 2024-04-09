import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactsStreamBuilder extends StatelessWidget {
  const ContactsStreamBuilder({
    Key? key,
    required this.height,
    required this.width,
    this.isSelectingForgroups = false,
  }) : super(key: key);

  final double height;
  final double width;
  final bool isSelectingForgroups;

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    return StreamBuilder(
      stream: ChatService.getContactsId(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return StreamBuilder(
            stream: ChatService.getAllUsers(
                snapshot.data!.docs.map((e) => e.id).toList()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                List<ChatUser> listOfChatUsers = data.map((e) {
                  ChatUser chatUser = ChatUser.fromJson(e.data());

                  return chatUser;
                }).toList();
                c.addFirebaseContactsTolist(listOfChatUsers);

                return GetBuilder<ContactScreenController>(builder: (_) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: ListView.builder(
                        itemCount: _.foundedUsers.length,
                        itemBuilder: (context, index) {
                          _.firebaseContacts.sort((a, b) {
                            return a.name!
                                .toLowerCase()
                                .compareTo(b.name!.toLowerCase());
                          });
                          if (index == 0 ||
                              _.foundedUsers[index].name![0] !=
                                  _.foundedUsers[index - 1].name![0]) {
                            return StreamBuilder(
                              stream: ChatService.getNicknameStream(
                                  _.foundedUsers[index].id!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data;
                                  if (data != null && data.exists) {
                                    var nicknameField =
                                        'nickName${_.foundedUsers[index].id!}';
                                    var nicknameExists =
                                        data.data()?[nicknameField] != null;

                                    if (nicknameExists) {
                                      var nickName =
                                          data.data()?[nicknameField] ?? "";
                                      var chatUser = _.foundedUsers[index];
                                      chatUser.name = nickName;
                                      _.foundedUsers[index] = chatUser;
                                    }
                                  }
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomTextWidget(
                                          text: _.foundedUsers[index].name![0],
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        const Expanded(
                                          child: Divider(
                                            thickness: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      onTap: () async {
                                        if (isSelectingForgroups) {
                                          if (!_.selectedMembers.contains(
                                              _.foundedUsers[index])) {
                                            _.selectedMembers
                                                .add(_.foundedUsers[index]);
                                          } else {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Already Selected this Member",
                                            );
                                          }
                                        } else {
                                          Get.to(
                                            () => ChattingScreen(
                                              chatUser:
                                                  _.firebaseContacts[index],
                                            ),
                                          );
                                        }
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          _.foundedUsers[index].image!,
                                        ),
                                      ),
                                      title: Text(_.foundedUsers[index].name!),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return StreamBuilder(
                                stream: ChatService.getNicknameStream(
                                    _.foundedUsers[index].id!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data;
                                    if (data != null && data.exists) {
                                      var nicknameField =
                                          'nickName${_.foundedUsers[index].id!}';
                                      var nicknameExists =
                                          data.data()?[nicknameField] != null;

                                      if (nicknameExists) {
                                        var nickName =
                                            data.data()?[nicknameField] ?? "";
                                        var chatUser = _.foundedUsers[index];
                                        chatUser.name = nickName;
                                        _.foundedUsers[index] = chatUser;
                                      }
                                    }
                                  }

                                  return ListTile(
                                    onTap: () async {
                                      if (isSelectingForgroups) {
                                        if (!_.selectedMembers
                                            .contains(_.foundedUsers[index])) {
                                          _.selectedMembers
                                              .add(_.foundedUsers[index]);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Already Selected this Member",
                                          );
                                        }
                                      } else {
                                        Get.to(
                                          () => ChattingScreen(
                                            chatUser: _.firebaseContacts[index],
                                          ),
                                        );
                                      }
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        _.foundedUsers[index].image!,
                                      ),
                                    ),
                                    title: Text(_.foundedUsers[index].name!),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  );
                });
              } else {
                return Center(child: SizedBox.shrink());
              }
            },
          );
        } else {
          return Center(child: SizedBox.shrink());
        }
      },
    );
  }
}
