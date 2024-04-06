import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/group_chat_screen.dart';
import 'package:doots/view/chats_screen/widgets/icons_and_types_of_last_msg.dart';
import 'package:doots/view/chats_screen/widgets/list_of_chats.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ArchivedChatsScreen extends StatelessWidget {
  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var chatCtr = Get.put(ChattingScreenController());
    var c = Get.put(ContactScreenController());
    var width = context.width;
    var height = context.height;
    var data = GetStorage();

    return Scaffold(
      appBar: AppBar(
        title: Text("Archived"),
      ),
      body: GetBuilder<ChattingScreenController>(builder: (__) {
        return ListView.builder(
          itemCount: chatCtr.archivedChats.toList().length,
          itemBuilder: (BuildContext context, int index) {
            var archivedChats = chatCtr.archivedChats.toList()[index];
            return ListTile(
              onTap: () async {
                if (archivedChats.type == 'user') {
                  var currentChatUser = chatCtr.contacts
                      .firstWhere((user) => user.id == archivedChats.id);
                  c.currentChatUserId(currentChatUser.id);
                  Get.to(
                    () => ChattingScreen(chatUser: currentChatUser),
                  );
                } else {
                  Get.to(
                    () => GroupChatScreen(
                      groupPhoto: archivedChats.imageUrl,
                      chatUserName: archivedChats.name,
                      groupId: archivedChats.id,
                    ),
                  );
                }
              },
              onLongPress: () {
                var currentChatItem = chatCtr.archivedChats.toList()[index];
                chatCtr.archivedChats.remove(currentChatItem);
                chatCtr.update();

                List<Map<String, dynamic>> chatMaps = chatCtr.archivedChats
                    .map((chatItem) => chatItem.toMap())
                    .toList();
                data.write("archive${ChatService.user.uid}", chatMaps);
              },
              trailing: ListOfChatsTrailing(
                  width: width, height: height, chatItems: archivedChats),
              leading: CircleAvatar(
                radius: width * 0.07,
                backgroundImage:
                    CachedNetworkImageProvider(archivedChats.imageUrl),
              ),
              title: Text(archivedChats.name),
              subtitle: archivedChats.type == "user"
                  ? StreamBuilder(
                      stream: ChatService.getLastMessage(archivedChats.id),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          final messageData = snapshot.data!.docs;
                          final list = messageData
                              .map((e) => Message.fromJson(e.data()))
                              .toList();

                          if (list.isNotEmpty) {
                            if (types.contains(list[0].messageType)) {
                              return Row(
                                children: [
                                  Icon(
                                    getMessageIcon(list[0].messageType),
                                    size: width * 0.05,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  kWidth(width * 0.02),
                                  Text(list[0].messageType),
                                ],
                              );
                            } else {
                              return Text(list[0].msg);
                            }
                          } else {
                            return Text("Send your First Message");
                          }
                        } else {
                          return Text("loading..");
                        }
                      })
                  : StreamBuilder(
                      stream:
                          ChatService.getLastMessageOfGroup(archivedChats.id),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          final messageData = snapshot.data!.docs;

                          final list = messageData
                              .map((e) => Message.fromJson(e.data()))
                              .toList();

                          if (list.isNotEmpty) {
                            if (types.contains(list[0].messageType)) {
                              return Row(
                                children: [
                                  Icon(
                                    getMessageIcon(list[0].messageType),
                                    size: width * 0.05,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  kWidth(width * 0.02),
                                  Text(list[0].messageType),
                                ],
                              );
                            } else {
                              return Text(list[0].msg);
                            }
                          } else {
                            return const Text("New Group Created");
                          }
                        } else {
                          return const Text("loading..");
                        }
                      }),
            );
          },
        );
      }),
    );
  }
}
