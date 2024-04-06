import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/group_chat_screen.dart';
import 'package:doots/view/chats_screen/archived_chats_screen.dart';
import 'package:doots/view/chats_screen/widgets/create_contact_or_grp.dart';
import 'package:doots/view/chats_screen/widgets/icons_and_types_of_last_msg.dart';
import 'package:doots/view/chats_screen/widgets/list_of_chats.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfilePageController());
    var chatCtr = Get.put(ChattingScreenController());
    var height = context.height;
    var width = context.width;
    var data = GetStorage();
    var c = Get.put(ContactScreenController());
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
                onChanged: (value) {
                  chatCtr.runfilter(value);
                },
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                prefix: const Icon(Icons.search),
                hintText: "Search here.."),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => ArchivedChatsScreen());
              },
              leading: IconButton(onPressed: null, icon: Icon(Icons.archive)),
              title: Text("Archived"),
            ),
            ListOfPinnedChats(
                chatCtr: chatCtr,
                c: c,
                data: data,
                width: width,
                height: height),
            ListOfChats(height: height, width: width),
          ],
        ),
      ),
    );
  }
}

class ListOfPinnedChats extends StatelessWidget {
  const ListOfPinnedChats({
    super.key,
    required this.chatCtr,
    required this.c,
    required this.data,
    required this.width,
    required this.height,
  });

  final ChattingScreenController chatCtr;
  final ContactScreenController c;
  final GetStorage data;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChattingScreenController>(builder: (__) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: chatCtr.pinnedChats.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              if (chatCtr.pinnedChats.toList()[index].type == 'user') {
                var currentChatUser = chatCtr.contacts.firstWhere((user) =>
                    user.id == chatCtr.pinnedChats.toList()[index].id);
                c.currentChatUserId(currentChatUser.id);
                Get.to(
                  () => ChattingScreen(chatUser: currentChatUser),
                );
              } else {
                Get.to(
                  () => GroupChatScreen(
                    groupPhoto: chatCtr.pinnedChats.toList()[index].imageUrl,
                    chatUserName: chatCtr.pinnedChats.toList()[index].name,
                    groupId: chatCtr.pinnedChats.toList()[index].id,
                  ),
                );
              }
            },
            onLongPress: () {
              var currentChatItem = chatCtr.pinnedChats.toList()[index];
              chatCtr.pinnedChats.remove(currentChatItem);
              chatCtr.update();
              List<Map<String, dynamic>> chatMaps = chatCtr.pinnedChats
                  .map((chatItem) => chatItem.toMap())
                  .toList();
              data.write(ChatService.user.uid, chatMaps);
            },
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.push_pin),
                ListOfChatsTrailing(
                    width: width,
                    height: height,
                    chatItems: chatCtr.pinnedChats.toList()[index])
              ],
            ),
            leading: CircleAvatar(
              radius: width * 0.07,
              backgroundImage: CachedNetworkImageProvider(
                  chatCtr.pinnedChats.toList()[index].imageUrl),
            ),
            title: Text(chatCtr.pinnedChats.toList()[index].name),
            subtitle: chatCtr.pinnedChats.toList()[index].type == "user"
                ? StreamBuilder(
                    stream: ChatService.getLastMessage(
                        chatCtr.pinnedChats.toList()[index].id),
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
                    stream: ChatService.getLastMessageOfGroup(
                        chatCtr.pinnedChats.toList()[index].id),
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
    });
  }
}
