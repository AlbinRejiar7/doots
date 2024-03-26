// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/constants/color_constants.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyWidget extends StatelessWidget {
  final Message message;
  final String chatUserName;
  final ChatUser? chatUser;

  const ReplyWidget(
      {super.key,
      required this.message,
      required this.chatUserName,
      required this.chatUser});

  @override
  Widget build(BuildContext context) {
    bool isUser = (message.fromId == ChatService.user.uid);

    if (!isUser && message.read.isEmpty) {
      ChatService.updateMessageStatus(message);
    }
    AppLifecycleListener(
      onResume: () {
        ChatService.updateMessageStatus(message);
      },
    );
    var height = Get.height;
    var width = Get.width;

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: isUser
                ? EdgeInsets.only(left: width * 0.4)
                : EdgeInsets.only(right: width * 0.4),
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              color: kgreen1.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.03),
                  topRight: Radius.circular(width * 0.03),
                  bottomLeft: isUser
                      ? Radius.circular(width * 0.05)
                      : const Radius.circular(0),
                  bottomRight: isUser
                      ? const Radius.circular(0)
                      : Radius.circular(width * 0.03)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: width * 0.01,
                        height: height * 0.02,
                        color: isUser ? Colors.blue : Colors.redAccent),
                    kWidth(width * 0.02),
                    if (chatUser != null)
                      Text(
                        isUser ? "you" : chatUser?.name! ?? "null",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    else
                      Text(
                        isUser ? "you" : chatUserName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.02),
                  child: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      message.msg,
                      style: Theme.of(context).textTheme.bodyLarge!),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Text(
                    message.replyMessage,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                  ChatService.convertTimestampTo12HrTime(
                      int.parse(message.sent)),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 12)),
              if (message.read.isEmpty)
                isUser
                    ? Icon(
                        size: width * 0.05,
                        Icons.done,
                      )
                    : SizedBox.fromSize(),
              if (message.read.isNotEmpty)
                isUser
                    ? Icon(
                        size: width * 0.05,
                        Icons.done_all,
                        color: Colors.blue,
                      )
                    : SizedBox.fromSize(),
            ],
          ),
        ],
      ),
    );
  }
// }Row(
//       mainAxisAlignment:
//           isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         !isUser
//             ? Container(
//                 color: Colors.amber,
//                 width: width * 0.01,
//                 height: height * 0.07,
//               )
//             : SizedBox(),
//         Container(
//           margin: EdgeInsets.all(width * 0.02),
//           padding: EdgeInsets.all(width * 0.02),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: kgreen1.withOpacity(0.9)),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         isUser ? "you" : chatUser.name!,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         message.msg,
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     ],
//                   ),
//                   Text(message.replyMessage),
//                 ],
//               )
//             ],
//           ),
//         ),
//         isUser
//             ? Container(
//                 color: Colors.amber,
//                 width: width * 0.01,
//                 height: height * 0.07,
//               )
//             : SizedBox()
//       ],
//     );
}
