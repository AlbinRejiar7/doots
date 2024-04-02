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
                name: ChatService.user.displayName ?? "null");
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
          return SizedBox(
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
                        onLongPress: () async {
                          audioCtr.changeIconSize(.09);
                          if (await Permission.microphone.isGranted) {
                            audioCtr.startOrStopRecording(
                                chatUserId: chatUserId, groupId: groupId);
                          } else {
                            await Permission.microphone.request();
                          }
                        },
                        onLongPressEnd: (details) async {
                          audioCtr.changeIconSize(0.06);

                          if (await Permission.microphone.isGranted) {
                            audioCtr.startOrStopRecording(
                                chatUserId: chatUserId, groupId: groupId);
                          }
                        },
                        child: const Icon(Icons.mic, color: kWhite));
              }),
            ),
          );
        }),
      ),
    );
  }
}

// class MicAndSendButtonWidgetGroup extends StatelessWidget {
//   const MicAndSendButtonWidgetGroup({
//     super.key,
//     required this.c,
//     required this.height,
//     required this.audioCtr,
//     required this.groupId,
//   });
//   final ChattingScreenController c;
//   final double height;
//   final AudioController audioCtr;
//   final String groupId;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (c.chatCtr.text.isNotEmpty) {
//           ChatService.sendMessage(
//             isGroupChat: true,
//             groupId: groupId,
//             msg: c.chatCtr.text,
//             type: 'text',
//           );
//           c.chatCtr.clear();

//           c.changeMicState(true);
//         }
//       },
//       child: AnimatedContainer(
//         duration:
//             const Duration(milliseconds: 300), // Adjust duration as needed
//         curve: Curves.easeInOut,

//         child: Obx(() {
//           return SizedBox(
//             height: height * audioCtr.iconSize.value,
//             width: height * audioCtr.iconSize.value,
//             child: Card(
//               elevation: 0,
//               color: kGreen,
//               shape: CircleBorder(),
//               child: Obx(() {
//                 return !c.isMic.value
//                     ? const Icon(
//                         Icons.send,
//                         color: kWhite,
//                       )
//                     : GestureDetector(
//                         onLongPress: () async {
//                           audioCtr.changeIconSize(.09);
//                           if (await Permission.microphone.isGranted) {
//                             // audioCtr.startOrStopRecording();
//                           } else {
//                             await Permission.microphone.request();
//                           }
//                         },
//                         onLongPressEnd: (details) async {
//                           audioCtr.changeIconSize(0.06);

//                           if (await Permission.microphone.isGranted) {
//                             // audioCtr.startOrStopRecording();
//                           }
//                         },
//                         child: const Icon(Icons.mic, color: kWhite));
//               }),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
