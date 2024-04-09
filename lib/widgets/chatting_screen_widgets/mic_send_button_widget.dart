import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MicAndSendButtonWidget extends StatelessWidget {
  const MicAndSendButtonWidget({
    super.key,
    required this.c,
    required this.height,
    required this.audioCtr,
    required this.chatUserId,
    required this.groupId,
  });
  final String chatUserId;
  final String groupId;
  final ChattingScreenController c;
  final double height;
  final AudioController audioCtr;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (c.chatCtr.text.isNotEmpty &&
            c.chats.isNotEmpty &&
            chatUserId.isNotEmpty) {
          if (c.chatCtr.text.isNotEmpty && c.isReply.value == false) {
            ChatService.sendMessage(
              chatUserId: chatUserId,
              groupId: groupId,
              msg: c.chatCtr.text,
              type: 'text',
            );

            c.chatCtr.clear();
            ChatService.updateIsTypingStatus(chatUserId, false);
            c.changeMicState(true);
          }
          if (c.chatCtr.text.isNotEmpty && c.isReply.value) {
            ChatService.sendMessage(
              chatUserId: chatUserId,
              groupId: groupId,
              msg: c.chosenReplyMessage.value.msg,
              type: 'reply',
              replyMessage: c.chatCtr.text,
            );

            c.isReplyWidgetOn(false);
            c.chatCtr.clear();
            ChatService.updateIsTypingStatus(chatUserId, false);
            c.changeMicState(true);
          }
        } else {
          if (groupId.isNotEmpty && c.chatCtr.text.isNotEmpty) {
            ChatService.sendMessage(
              chatUserId: chatUserId,
              groupId: groupId,
              msg: c.chatCtr.text,
              type: 'text',
            );
            c.chatCtr.clear();
            ChatService.updateIsTypingStatusOfGroup(groupId, false);
            c.changeMicState(true);
          } else {
            if (c.chatCtr.text.isNotEmpty) {
              ChatService.sendFirstMessage(chatUserId, c.chatCtr.text, 'text');
              c.chatCtr.clear();
            }
          }
        }
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 300), // Adjust duration as needed
        curve: Curves.easeInOut,

        child: Obx(() {
          return Row(
            children: [
              Visibility(
                visible: audioCtr.isRecording.value == false,
                child: SizedBox(
                  height: height * audioCtr.iconSize.value,
                  width: height * audioCtr.iconSize.value,
                  child: Card(
                    elevation: 0,
                    color: kGreen,
                    shape: CircleBorder(),
                    child: Obx(() {
                      return !c.isMic.value
                          ? const Icon(
                              Icons.send,
                              color: kWhite,
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (await Permission.microphone.isGranted) {
                                  audioCtr.startOrStopRecording(
                                      chatUserId: chatUserId, groupId: groupId);
                                } else {
                                  await Permission.microphone.request();
                                }
                              },
                              child: const Icon(Icons.mic, color: kWhite));
                    }),
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: audioCtr.isRecording.value,
                  child: Row(
                    children: [
                      CloseButton(
                        onPressed: () async {
                          await audioCtr.cancelRecording();
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            if (await Permission.microphone.isGranted) {
                              audioCtr.startOrStopRecording(
                                  chatUserId: chatUserId, groupId: groupId);
                            }
                          },
                          icon: Icon(Icons.send)),
                    ],
                  ),
                );
              })
            ],
          );
        }),
      ),
    );
  }
}
