import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/models/chat_items.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/group_chat_screen.dart';
import 'package:doots/view/chats_screen/widgets/icons_and_types_of_last_msg.dart';
import 'package:doots/view/chats_screen/widgets/unread_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListOfChats extends StatelessWidget {
  const ListOfChats({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    var chatsCtr = Get.put(ChattingScreenController());
    var c = Get.put(ContactScreenController());

    var localPinnedChats = GetStorage();
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
                  chatsCtr.allChats.clear();

                  chatsCtr.contacts.addAll(data.map((e) {
                    ChatUser chatUser = ChatUser.fromJson(e.data());
                    // Check if isPhotoVisible is false
                    if (!chatUser.isPhotoOn!) {
                      // If isPhotoVisible is false, set a new photoUrl link
                      chatUser.image =
                          "https://www.dpforwhatsapp.in/img/no-dp/19.webp";
                    }
                    return chatUser;
                  }).toList());

                  chatsCtr.allChats.addAll(data
                      .map((e) => ChatItem(
                          id: e.get("id"),
                          name: e.get("name"),
                          type: 'user',
                          imageUrl: e.get('is_photo_on') as bool
                              ? e.get('image')
                              : "https://www.dpforwhatsapp.in/img/no-dp/19.webp"))
                      .toList());
                }

                if (chatsCtr.allChats.isNotEmpty) {
                  return StreamBuilder(
                      stream: ChatService.getGroups(),
                      builder: (context, groupsnapshot) {
                        var data = groupsnapshot.data?.docs;

                        if (data != null) {
                          chatsCtr.allChats.addAll(data
                              .map((e) => ChatItem(
                                  id: e.get("groupId"),
                                  name: e.get("groupName"),
                                  type: 'group',
                                  imageUrl: e.get('photoUrl') ??
                                      "https://i.pinimg.com/736x/38/11/d8/3811d876c4397073393b7ff9fbd2b48a.jpg"))
                              .where((groupChat) => !chatsCtr.allChats
                                  .any((chat) => chat.id == groupChat.id))
                              .toList());
                        }
                        chatsCtr.foundedChatItem.removeWhere((chatItem) =>
                            chatsCtr.pinnedChats.contains(chatItem));

                        return Padding(
                            padding: EdgeInsets.only(top: height * 0.01),
                            child: GetBuilder(
                                init: ChattingScreenController(),
                                builder: (cr) {
                                  return ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.22),
                                      child: const Divider(
                                        thickness: 0.2,
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    itemCount: chatsCtr.foundedChatItem.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onLongPress: () {
                                          if (chatsCtr.pinnedChats.length < 3) {
                                            chatsCtr.pinnedChats.add(chatsCtr
                                                .foundedChatItem[index]);

                                            List<Map<String, dynamic>>
                                                chatMaps = chatsCtr.pinnedChats
                                                    .map((chatItem) =>
                                                        chatItem.toMap())
                                                    .toList();
                                            localPinnedChats.write(
                                                ChatService.user.uid, chatMaps);
                                            chatsCtr.foundedChatItem
                                                .removeWhere((chatItem) =>
                                                    chatsCtr.pinnedChats
                                                        .contains(chatItem));
                                            Fluttertoast.showToast(
                                                msg: "Chat Pinned");
                                            chatsCtr.update();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Only 3 chats can be pinned");
                                          }
                                        },
                                        onTap: () async {
                                          if (chatsCtr.foundedChatItem[index]
                                                  .type ==
                                              'user') {
                                            var currentChatUser = chatsCtr
                                                .contacts
                                                .firstWhere((user) =>
                                                    user.id ==
                                                    chatsCtr
                                                        .foundedChatItem[index]
                                                        .id);
                                            c.currentChatUserId(
                                                currentChatUser.id);
                                            Get.to(
                                              () => ChattingScreen(
                                                  chatUser: currentChatUser),
                                            );
                                          } else {
                                            Get.to(
                                              () => GroupChatScreen(
                                                groupPhoto: chatsCtr
                                                    .foundedChatItem[index]
                                                    .imageUrl,
                                                chatUserName: chatsCtr
                                                    .foundedChatItem[index]
                                                    .name,
                                                groupId: chatsCtr
                                                    .foundedChatItem[index].id,
                                              ),
                                            );
                                          }
                                        },
                                        subtitle: chatsCtr
                                                    .foundedChatItem[index]
                                                    .type ==
                                                "user"
                                            ? StreamBuilder(
                                                stream: ChatService
                                                    .getLastMessage(chatsCtr
                                                        .foundedChatItem[index]
                                                        .id),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data != null) {
                                                    final messageData =
                                                        snapshot.data!.docs;
                                                    final list = messageData
                                                        .map((e) =>
                                                            Message.fromJson(
                                                                e.data()))
                                                        .toList();

                                                    if (list.isNotEmpty) {
                                                      chatsCtr.foundedChatItem[index] =
                                                          ChatItem(
                                                              id: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .id,
                                                              name: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .name,
                                                              type:
                                                                  'user', // or 'group'
                                                              imageUrl: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .imageUrl,
                                                              lastMessageAt:
                                                                  list[0].sent);

                                                      if (types.contains(list[0]
                                                          .messageType)) {
                                                        return Row(
                                                          children: [
                                                            Icon(
                                                              getMessageIcon(list[
                                                                      0]
                                                                  .messageType),
                                                              size:
                                                                  width * 0.05,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            kWidth(
                                                                width * 0.02),
                                                            Text(list[0]
                                                                .messageType),
                                                          ],
                                                        );
                                                      } else {
                                                        return Text(
                                                            list[0].msg);
                                                      }
                                                    } else {
                                                      return Text(
                                                          "Send your First Message");
                                                    }
                                                  } else {
                                                    return Text("loading..");
                                                  }
                                                })
                                            : StreamBuilder(
                                                stream: ChatService
                                                    .getLastMessageOfGroup(
                                                        chatsCtr
                                                            .foundedChatItem[
                                                                index]
                                                            .id),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data != null) {
                                                    final messageData =
                                                        snapshot.data!.docs;

                                                    final list = messageData
                                                        .map((e) =>
                                                            Message.fromJson(
                                                                e.data()))
                                                        .toList();

                                                    if (list.isNotEmpty) {
                                                      chatsCtr.foundedChatItem[
                                                              index] =
                                                          ChatItem(
                                                              id: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .id,
                                                              name: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .name,
                                                              type: 'group',
                                                              imageUrl: chatsCtr
                                                                  .foundedChatItem[
                                                                      index]
                                                                  .imageUrl,
                                                              lastMessageAt:
                                                                  list[0].sent);
                                                      if (types.contains(list[0]
                                                          .messageType)) {
                                                        return Row(
                                                          children: [
                                                            Icon(
                                                              getMessageIcon(list[
                                                                      0]
                                                                  .messageType),
                                                              size:
                                                                  width * 0.05,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            kWidth(
                                                                width * 0.02),
                                                            Text(list[0]
                                                                .messageType),
                                                          ],
                                                        );
                                                      } else {
                                                        return Text(
                                                            list[0].msg);
                                                      }
                                                    } else {
                                                      return const Text(
                                                          "New Group Created");
                                                    }
                                                  } else {
                                                    return const Text(
                                                        "loading..");
                                                  }
                                                }),
                                        subtitleTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontSize: 13,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                        trailing: ListOfChatsTrailing(
                                          width: width,
                                          height: height,
                                          chatItems:
                                              chatsCtr.foundedChatItem[index],
                                        ),
                                        leading: CircleAvatar(
                                          radius: width * 0.07,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  chatsCtr
                                                      .foundedChatItem[index]
                                                      .imageUrl),
                                        ),
                                        title: Text(chatsCtr
                                            .foundedChatItem[index].name),
                                      );
                                    },
                                  );
                                }));
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

class ListOfChatsTrailing extends StatelessWidget {
  const ListOfChatsTrailing({
    super.key,
    required this.width,
    required this.height,
    required this.chatItems,
  });

  final double width;
  final double height;
  final ChatItem chatItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chatItems.type == "user")
          StreamBuilder(
            stream: ChatService.getLastMessage(chatItems.id),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final messageData = snapshot.data!.docs;

                final list =
                    messageData.map((e) => Message.fromJson(e.data())).toList();
                if (list.isNotEmpty) {
                  return Text(ChatService.convertTimestampTo12HrTime(
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
            stream: ChatService.getLastMessageOfGroup(chatItems.id),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final messageData = snapshot.data!.docs;

                final list =
                    messageData.map((e) => Message.fromJson(e.data())).toList();
                if (list.isNotEmpty) {
                  return Text(ChatService.convertTimestampTo12HrTime(
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
        if (chatItems.type == 'user')
          StreamBuilder(
            stream: ChatService.getUnreadCount(chatItems.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.hasData && snapshot.data! != 0) {
                int unreadCount = snapshot.data!;
                return UnReadCountWidget(
                    height: height, unreadCount: unreadCount);
              }

              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
