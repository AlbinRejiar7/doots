// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/view/chating_screen/user_details_screen.dart';
import 'package:doots/widgets/custom_attachement_card.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_message_package/voice_message_package.dart';

enum MessageType {
  text,
  audio,
  document,
}

class ChattingScreen extends StatelessWidget {
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> title = [
      'ATTACHMENT',
      "CAMERA",
      "GALLERY",
      "AUDIO",
      "LOCATION",
      "CONTACTS",
      "AUDIO",
    ];
    List<IconData> myIcons = [
      Icons.edit_document,
      Icons.camera_alt,
      Icons.photo_library,
      Icons.headset,
      Icons.location_on,
      Icons.contacts,
      Icons.mic_none
    ];

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
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 12)),
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
                      print(chats);
                      if (chats[index]['type'] == MessageType.text) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(width * 0.02),
                                decoration: BoxDecoration(
                                    color: kGreen.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(chats[index]['chats'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                              Text(DateFormat.jm().format(DateTime.now()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 12)),
                            ],
                          ),
                        );
                      } else if (chats[index]['type'] == MessageType.document) {
                        return chats[index]['chats'] != null
                            ? GestureDetector(
                                onTap: () {
                                  documentCtr.openFile(chats[index]['chats']);
                                },
                                child: Text(
                                  'Selected File: mala, Type: pdf}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              )
                            : SizedBox.shrink();
                      } else {
                        return Obx(() {
                          return audioCtr.isMicrophoneGranted.value
                              ? Container(
                                  padding: EdgeInsets.all(width * 0.02),
                                  alignment: Alignment.centerRight,
                                  child: VoiceMessage(
                                      played: false,
                                      audioSrc: chats[index]["chats"],
                                      me: true))
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
                                Get.bottomSheet(Container(
                                  padding: EdgeInsets.all(width * 0.05),
                                  height: height * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                    ),
                                    itemCount: title.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CustomAttachement(
                                          index: index,
                                          color: kgreen1.withOpacity(0.2),
                                          title: title[index],
                                          icon: myIcons[index]);
                                    },
                                  ),
                                ));
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
                          GestureDetector(
                            onTap: () {
                              if (c.chatCtr.text.isNotEmpty) {
                                c.addchat(
                                  c.chatCtr.text,
                                  MessageType.text,
                                );
                                c.chatCtr.clear();
                                c.changeMicState(true);
                              }
                            },
                            child: SizedBox(
                              height: height * 0.06,
                              width: height * 0.06,
                              child: Card(
                                elevation: 0,
                                color: kGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                child: Obx(() {
                                  return !c.isMic.value
                                      ? Icon(
                                          Icons.send,
                                          color: kWhite,
                                        )
                                      : GestureDetector(
                                          onLongPress: () async {
                                            print("pressing..........");

                                            if (await Permission
                                                .microphone.isGranted) {
                                              audioCtr.micPermission(
                                                  await Permission
                                                      .microphone.isGranted);

                                              audioCtr.startRecording();
                                            } else {
                                              await Permission.microphone
                                                  .request();
                                            }
                                          },
                                          onLongPressEnd: (details) async {
                                            print("ended........");
                                            await audioCtr.stopRecording();
                                            c.addchat(
                                              audioCtr
                                                  .universalRecordingPath.value,
                                              MessageType.audio,
                                            );
                                            if (kDebugMode) {
                                              print(
                                                  "${audioCtr.universalRecordingPath.value}this is the path ");
                                            }
                                          },
                                          child:
                                              Icon(Icons.mic, color: kWhite));
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: c.emojiShowing.value ? height * 0.35 : 0,
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              c.changeMicState(false);
                            },
                            textEditingController: c.chatCtr,
                            config: Config(
                              checkPlatformCompatibility: true,
                            ),
                          ),
                        );
                      }),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
