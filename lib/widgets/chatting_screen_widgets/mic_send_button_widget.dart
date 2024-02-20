import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:flutter/foundation.dart';
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
      child: SizedBox(
        height: height * 0.06,
        width: height * 0.06,
        child: Card(
          elevation: 0,
          color: kGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          child: Obx(() {
            return !c.isMic.value
                ? Icon(
                    Icons.send,
                    color: kWhite,
                  )
                : GestureDetector(
                    onLongPress: () async {
                      if (await Permission.microphone.isGranted) {
                        audioCtr.micPermission(
                            await Permission.microphone.isGranted);
                        audioCtr.startRecording();
                      } else {
                        await Permission.microphone.request();
                      }
                    },
                    onLongPressEnd: (details) async {
                      await audioCtr.stopRecording();
                      c.addchat(
                        audioCtr.universalRecordingPath.value,
                        MessageType.audio,
                      );
                      if (kDebugMode) {
                        print(
                            "${audioCtr.universalRecordingPath.value}this is the path ");
                      }
                    },
                    child: Icon(Icons.mic, color: kWhite));
          }),
        ),
      ),
    );
  }
}
