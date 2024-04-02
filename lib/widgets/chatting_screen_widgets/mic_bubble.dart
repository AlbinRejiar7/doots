// import 'package:doots/constants/color_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:voice_message_package/voice_message_package.dart';

// class MicBubble extends StatelessWidget {
//   const MicBubble({
//     super.key,
//     required this.width,
//     required this.chats,
//     required this.index,
//   });

//   final double width;
//   final List chats;
//   final int index;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//             padding: EdgeInsets.all(width * 0.02),
//             alignment: Alignment.centerRight,
//             child: VoiceMessage(
//                 meBgColor: kgreen1,
//                 played: false,
//                 audioSrc: chats[index]["chats"],
//                 me: true)),
//         Padding(
//           padding: EdgeInsets.only(right: width * 0.02),
//           child: Text(DateFormat.jm().format(DateTime.now()),
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontSize: 12)),
//         ),
//       ],
//     );
//   }
// }
