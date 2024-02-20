// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/view/chating_screen/user_details_screen.dart';
import 'package:doots/view/map_screen/map_screen.dart';
import 'package:doots/widgets/chatting_screen_widgets/chat_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/custom_bottom_sheet.dart';
import 'package:doots/widgets/chatting_screen_widgets/document_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/emoji_widget.dart';
import 'package:doots/widgets/chatting_screen_widgets/mic_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/mic_send_button_widget.dart';
import 'package:doots/widgets/chatting_screen_widgets/photo_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/video_bubble.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingScreen extends StatelessWidget {
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var c = Get.put(ChattingScreenController());
    var audioCtr = Get.put(AudioController());
    var documentCtr = Get.put(DocumentController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 0.1)),
        title: InkWell(
          onTap: () {
            Get.to(() => DetailsScreen());
          },
          child: Row(
            children: [
              CircleAvatar(),
              kWidth(width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "name",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text("last seen 7-2-2023, 2:22 pm",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 12, overflow: TextOverflow.ellipsis)),
                ],
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ))
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          if (c.emojiShowing.value) {
            c.changeEmojiState();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Obx(() {
                List chats = [];
                chats.addAll(c.chats.reversed);
                return Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (chats[index]['type'] == MessageType.text) {
                        return ChatBubble(
                          width: width,
                          chats: chats,
                          index: index,
                        );
                      } else if (chats[index]['type'] == MessageType.document) {
                        return chats[index]['chats'] != null
                            ? DocumentBubble(
                                width: width,
                                documentCtr: documentCtr,
                                chats: chats,
                                height: height,
                                index: index,
                              )
                            : SizedBox.shrink();
                      } else if (chats[index]['type'] == MessageType.photos) {
                        return PhotoBubble(
                          chats: chats,
                          height: height,
                          width: width,
                          index: index,
                        );
                      } else if (chats[index]['type'] == MessageType.videos) {
                        return VideoBubble(
                          chats: chats,
                          width: width,
                          height: height,
                          index: index,
                        );
                      } else if (chats[index]['type'] == MessageType.location) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => MapScreen(
                                  currentLocation: chats[index]['chats'],
                                ));
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("Current location "),
                          ),
                        );
                      } else {
                        return Obx(() {
                          return audioCtr.isMicrophoneGranted.value
                              ? MicBubble(
                                  width: width,
                                  chats: chats,
                                  index: index,
                                )
                              : SizedBox();
                        });
                      }
                    },
                  ),
                );
              }),
              Container(
                  width: width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 0.1))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.bottomSheet(CustomBottomSheet(
                                    width: width,
                                    height: height,
                                    title: title,
                                    myIcons: myIcons));
                              },
                              icon: Icon(Icons.more_horiz)),
                          Obx(() {
                            return IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  c.changeEmojiState();
                                },
                                icon: !c.emojiShowing.value
                                    ? Icon(Icons.emoji_emotions_outlined)
                                    : InkWell(
                                        onTap: () {
                                          c.changeEmojiState();
                                          FocusScope.of(context)
                                              .requestFocus(c.focusNode);
                                        },
                                        child: Icon(Icons.keyboard)));
                          }),
                          Expanded(child: Obx(() {
                            return CustomTextField(
                              onChanged: (value) {
                                if (c.chatCtr.text.isEmpty) {
                                  c.changeMicState(true);
                                } else {
                                  c.changeMicState(false);
                                }
                              },
                              focusNode: c.focusNode,
                              onTap: () {
                                if (c.emojiShowing.value) {
                                  c.changeEmojiState();
                                }
                              },
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              controller: c.chatCtr,
                              fillColor: Theme.of(context).primaryColor,
                              filled: true,
                              hintText: audioCtr.isRecording.value
                                  ? "RECORDING>>>>>>>"
                                  : 'Type your message...',
                              isBoarder: false,
                            );
                          })),
                          kWidth(2),
                          MicAndSendButtonWidget(
                              c: c, height: height, audioCtr: audioCtr),
                        ],
                      ),
                      EmojiWidget()
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
