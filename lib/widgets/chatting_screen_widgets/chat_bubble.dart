import 'package:doots/constants/color_constants.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String chatUserId;
  const ChatBubble({
    super.key,
    required this.message,
    required this.chatUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isUser = (message.fromId == ChatService.user.uid);
    if (!isUser && message.read.isEmpty) {
      ChatService.updateMessageStatus(message);
      if (chatUserId.isNotEmpty) {
        ChatService.resetUnreadCount(chatUserID: chatUserId);
      }
    }
    AppLifecycleListener(
      onResume: () {
        ChatService.updateMessageStatus(message);
      },
    );

    var width = context.width;

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
              color:
                  isUser ? kgreen1.withOpacity(0.2) : kgreen1.withOpacity(0.7),
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
            child: Text(message.msg,
                style: Theme.of(context).textTheme.bodyMedium),
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
}

class GroupChatBubble extends StatelessWidget {
  final Message message;

  const GroupChatBubble({
    super.key,
    required this.message,
  });

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

    var width = context.width;

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
              color:
                  isUser ? kgreen1.withOpacity(0.2) : kgreen1.withOpacity(0.7),
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
            child: Text(message.msg,
                style: Theme.of(context).textTheme.bodyMedium),
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
}
