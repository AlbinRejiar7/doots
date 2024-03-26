import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/models/chat_items.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/group_chat_screen.dart';
import 'package:doots/view/chats_screen/create_group.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.14,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chats",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                plusCardButton(
                  height,
                  () {
                    createContactOrGroup(context);
                  },
                )
              ],
            ),
            kHeight(height * 0.02),
            CustomTextField(
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                prefix: const Icon(Icons.search),
                hintText: "Search here.."),
          ],
        ),
      ),
      body: ListOfChats(c: c, height: height, width: width),
    );
  }

  Future<dynamic> createContactOrGroup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Text(
              "Please select your Option",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CloseButton(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kgreen1),
                onPressed: () {
                  Get.to(() => CreateContactPage(),
                      transition: Transition.downToUp);
                },
                icon: Icon(Icons.contact_page),
                label: Text("Add Contacts")),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kgreen1),
                onPressed: () {
                  Get.to(() => CreateNewGroup(),
                      transition: Transition.downToUp);
                },
                icon: Icon(Icons.group_outlined),
                label: Text("Create Group"))
          ],
        ),
      ),
    );
  }
}

// class GroupScreen extends StatelessWidget {
//   const GroupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var height = Get.height;
//     var width = Get.width;
//     List<GroupChat>? groups;
//     return Scaffold(
//       body: Padding(
//         padding:
//             EdgeInsets.fromLTRB(width * 0.03, width * 0.04, width * 0.03, 0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "CHANNELS",
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 plusCardButton(height, () {
//                   Get.to(() => CreateNewGroup(),
//                       transition: Transition.downToUp);
//                 })
//               ],
//             ),
//             Expanded(
//               child: StreamBuilder(
//                   stream: ChatService.getGroups(),
//                   builder: (context, snapshot) {
//                     var data = snapshot.data?.docs;
//                     groups = data
//                             ?.map((e) => GroupChat.fromJson(e.data()))
//                             .toList() ??
//                         [];
//                     log(groups.toString());

//                     if (data != null) {
//                       return ListView.separated(
//                         separatorBuilder: (context, index) => Padding(
//                           padding: EdgeInsets.only(left: width * 0.2),
//                           child: Divider(
//                             thickness: 0.2,
//                           ),
//                         ),
//                         itemCount: data.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           var groupId = data[index].id;
//                           log(groupId);
//                           if (groups != null) {
//                             return ListTile(
//                               onTap: () {
//                                 Get.to(() => GroupChatScreen(
//                                   chatUserName: ,
//                                       groupId: groupId,
//                                     ));
//                               },
//                               leading: CircleAvatar(
//                                 radius: 30,
//                               ),
//                               title: Text(groups![index].groupName),
//                               subtitle: Text("last Message"),
//                               subtitleTextStyle: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(fontSize: 13),
//                             );
//                           } else {
//                             return Text("null");
//                           }
//                         },
//                       );
//                     } else {
//                       return Text("null");
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ListOfChats extends StatelessWidget {
  const ListOfChats({
    super.key,
    required this.c,
    required this.height,
    required this.width,
  });

  final ContactScreenController c;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    List<ChatItem> allChats = [];
    List<ChatUser> contacts = [];
    return StreamBuilder(
        stream: ChatService.getContactsId(),
        builder: (context, snapshot) {
          if (snapshot.data?.docs.isNotEmpty ?? false) {
            return StreamBuilder(
              stream: ChatService.getAllUsers(
                  snapshot.data?.docs.map((e) => e.id).toList() ?? []),
              builder: (context, snapshot) {
                var data = snapshot.data?.docs;

                if (data != null) {
                  allChats.clear();

                  contacts.addAll(
                      data.map((e) => ChatUser.fromJson(e.data())).toList());

                  allChats.addAll(data
                      .map((e) => ChatItem(
                          id: e.get("id"),
                          name: e.get("name"),
                          type: 'user',
                          imageUrl: e.get('image')))
                      .toList());
                }

                if (allChats.isNotEmpty) {
                  return StreamBuilder(
                      stream: ChatService.getGroups(),
                      builder: (context, groupsnapshot) {
                        var data = groupsnapshot.data?.docs;

                        if (data != null) {
                          allChats.addAll(data
                              .map((e) => ChatItem(
                                  id: e.get("groupId"),
                                  name: e.get("groupName"),
                                  type: 'group',
                                  imageUrl: e.get('photoUrl') ??
                                      "https://i.pinimg.com/736x/38/11/d8/3811d876c4397073393b7ff9fbd2b48a.jpg"))
                              .where((groupChat) => !allChats
                                  .any((chat) => chat.id == groupChat.id))
                              .toList());
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.01),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(left: width * 0.22),
                              child: const Divider(
                                thickness: 0.2,
                              ),
                            ),
                            shrinkWrap: true,
                            itemCount: allChats.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async {
                                  if (allChats[index].type == 'user') {
                                    Get.to(
                                      () => ChattingScreen(
                                          chatUser: contacts.firstWhere(
                                              (user) =>
                                                  user.id ==
                                                  allChats[index].id)),
                                    );
                                  } else {
                                    Get.to(
                                      () => GroupChatScreen(
                                        groupPhoto: allChats[index].imageUrl,
                                        chatUserName: allChats[index].name,
                                        groupId: allChats[index].id,
                                      ),
                                    );
                                  }
                                },
                                subtitle: allChats[index].type == "user"
                                    ? StreamBuilder(
                                        stream: ChatService.getLastMessage(
                                            allChats[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            final messageData =
                                                snapshot.data!.docs;
                                            final list = messageData
                                                .map((e) =>
                                                    Message.fromJson(e.data()))
                                                .toList();

                                            if (list.isNotEmpty) {
                                              allChats[index] = ChatItem(
                                                  id: allChats[index].id,
                                                  name: allChats[index].name,
                                                  type: 'user', // or 'group'
                                                  imageUrl:
                                                      allChats[index].imageUrl,
                                                  lastMessageAt: list[0].sent);

                                              if (types.contains(
                                                  list[0].messageType)) {
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      getMessageIcon(
                                                          list[0].messageType),
                                                      size: width * 0.05,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    ),
                                                    kWidth(width * 0.02),
                                                    Text(list[0].messageType),
                                                  ],
                                                );
                                              } else {
                                                return Text(list[0].msg);
                                              }
                                            } else {
                                              return Text("loading..");
                                            }
                                          } else {
                                            return Text("loading..");
                                          }
                                        })
                                    : StreamBuilder(
                                        stream:
                                            ChatService.getLastMessageOfGroup(
                                                allChats[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            final messageData =
                                                snapshot.data!.docs;

                                            final list = messageData
                                                .map((e) =>
                                                    Message.fromJson(e.data()))
                                                .toList();

                                            if (list.isNotEmpty) {
                                              allChats[index] = ChatItem(
                                                  id: allChats[index].id,
                                                  name: allChats[index].name,
                                                  type: 'group',
                                                  imageUrl:
                                                      allChats[index].imageUrl,
                                                  lastMessageAt: list[0].sent);
                                              if (types.contains(
                                                  list[0].messageType)) {
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      getMessageIcon(
                                                          list[0].messageType),
                                                      size: width * 0.05,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    ),
                                                    kWidth(width * 0.02),
                                                    Text(list[0].messageType),
                                                  ],
                                                );
                                              } else {
                                                return Text(list[0].msg);
                                              }
                                            } else {
                                              return const Text(
                                                  "New Group Created");
                                            }
                                          } else {
                                            return const Text("loading..");
                                          }
                                        }),
                                subtitleTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (allChats[index].type == "user")
                                      StreamBuilder(
                                        stream: ChatService.getLastMessage(
                                            allChats[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            final messageData =
                                                snapshot.data!.docs;

                                            final list = messageData
                                                .map((e) =>
                                                    Message.fromJson(e.data()))
                                                .toList();
                                            if (list.isNotEmpty) {
                                              return Text(ChatService
                                                  .convertTimestampTo12HrTime(
                                                      int.parse(list[0].sent)));
                                            } else {
                                              return Text("");
                                            }
                                          } else {
                                            return Text("");
                                          }
                                        },
                                      )
                                    else
                                      StreamBuilder(
                                        stream:
                                            ChatService.getLastMessageOfGroup(
                                                allChats[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            final messageData =
                                                snapshot.data!.docs;

                                            final list = messageData
                                                .map((e) =>
                                                    Message.fromJson(e.data()))
                                                .toList();
                                            if (list.isNotEmpty) {
                                              return Text(ChatService
                                                  .convertTimestampTo12HrTime(
                                                      int.parse(list[0].sent)));
                                            } else {
                                              return Text("");
                                            }
                                          } else {
                                            return Text("");
                                          }
                                        },
                                      ),
                                    kWidth(width * 0.02),
                                    if (allChats[index].type == 'user')
                                      StreamBuilder(
                                        stream: ChatService.getUnreadCount(
                                            allChats[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          if (snapshot.hasData &&
                                              snapshot.data! != 0) {
                                            int unreadCount = snapshot.data!;
                                            return UnReadCountWidget(
                                                height: height,
                                                unreadCount: unreadCount);
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: width * 0.07,
                                  backgroundImage: CachedNetworkImageProvider(
                                      allChats[index].imageUrl ?? "loading.."),
                                ),
                                title:
                                    Text(allChats[index].name ?? "loading.."),
                              );
                            },
                          ),
                        );
                      });
                } else {
                  return Text(
                    "Add Contacts To Chat",
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

List<String> types = [
  'document',
  'image',
  'audio',
  'video',
];
IconData getMessageIcon(String type) {
  switch (type) {
    case 'document':
      return Icons.file_copy;
    case 'image':
      return Icons.image;
    case 'audio':
      return Icons.audiotrack;
    case 'video':
      return Icons.videocam;
    default:
      return Icons.circle; // Empty space for other types
  }
}

class UnReadCountWidget extends StatelessWidget {
  const UnReadCountWidget({
    super.key,
    required this.height,
    required this.unreadCount,
  });

  final double height;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.03,
      width: height * 0.03,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        color: kgreen1,
        child: Center(
          child: Text(
            unreadCount.toString(),
            style: TextStyle(color: kWhite, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
// Padding(
//           padding:
//               EdgeInsets.fromLTRB(width * 0.03, width * 0.04, width * 0.03, 0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Text(
//                 //   "FAVORITE",
//                 //   style: Theme.of(context).textTheme.bodyLarge,
//                 // ),
//                 // ListView.builder(
//                 //   physics: NeverScrollableScrollPhysics(),
//                 //   shrinkWrap: true,
//                 //   itemCount: c.foundedUsers.length,
//                 //   itemBuilder: (BuildContext context, int index) {
//                 //     if (c.foundedUsers[index]['isFav'].value) {
//                 //       return ListTile(
//                 //         leading: CircleAvatar(
//                 //           backgroundImage: NetworkImage(
//                 //               "https://instacaptionsforall.in/wp-content/uploads/2023/12/50-5.jpg"),
//                 //         ),
//                 //         title: Text("c.foundedUsers[index]['name']"),
//                 //       );
//                 //     } else {
//                 //       return SizedBox();
//                 //     }
//                 //   },
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Text(
//                 //       "DIRECT MESSAGES",
//                 //       style: Theme.of(context).textTheme.bodyLarge,
//                 //     ),
//                 //     plusCardButton(height, () {
//                 //       // Get.to(() => Wave());
//                 //       // Get.to(() => DirectMessages(),
//                 //       //     transition: Transition.downToUp);
//                 //     })
//                 //   ],
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Text(
//                 //       "CHANNELS",
//                 //       style: Theme.of(context).textTheme.bodyLarge,
//                 //     ),
//                 //     plusCardButton(height, () {
//                 //       Get.to(() => CreateNewGroup(),
//                 //           transition: Transition.downToUp);
//                 //     })
//                 //   ],
//                 // ),
//                 ListOfChats(c: c, height: height, width: width)
//               ],
//             ),
//           ),
//         ),