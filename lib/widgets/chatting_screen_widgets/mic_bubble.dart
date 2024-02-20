import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MicBubble extends StatelessWidget {
  const MicBubble({
    super.key,
    required this.width,
    required this.chats,
    required this.index,
  });

  final double width;
  final List chats;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(width * 0.02),
        alignment: Alignment.centerRight,
        child: VoiceMessage(
            played: false, audioSrc: chats[index]["chats"], me: true));
  }
}
