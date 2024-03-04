import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MicAndSendButtonWidget extends StatelessWidget {
  const MicAndSendButtonWidget({
    super.key,
    required this.c,
    required this.height,
    required this.audioCtr,
  });

  final ChattingScreenController c;
  final double height;
  final AudioController audioCtr;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Adjust duration as needed
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
                            audioCtr.micPermission(
                                await Permission.microphone.isGranted);
                            audioCtr.startRecording();
                          } else {
                            await Permission.microphone.request();
                          }
                        },
                        onLongPressEnd: (details) async {
                          audioCtr.changeIconSize(0.06);
                          await audioCtr.stopRecording();
                          if (await Permission.microphone.isGranted) {
                            c.addchat(
                              audioCtr.universalRecordingPath.value,
                              MessageType.audio,
                            );
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
