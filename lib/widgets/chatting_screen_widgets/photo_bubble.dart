import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoBubble extends StatelessWidget {
  const PhotoBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    bool isUser = (message.fromId == ChatService.user.uid);

    if (!isUser && message.read.isEmpty) {
      ChatService.updateMessageStatus(message);
    }
    return GestureDetector(
      onTap: () {
        Get.to(
            () => PhotoViewer(
                  isUser: isUser,
                  image: message.msg,
                ),
            transition: Transition.fadeIn);
      },
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Container(
          padding: EdgeInsets.all(width * 0.01),
          margin: isUser
              ? EdgeInsets.only(left: width * 0.46)
              : EdgeInsets.only(right: width * 0.46),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.02),
                topRight: Radius.circular(width * 0.02),
                bottomLeft:
                    isUser ? Radius.circular(width * 0.02) : Radius.circular(0),
                bottomRight: isUser
                    ? Radius.circular(0)
                    : Radius.circular(width * 0.02)),
            color: isUser
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.tertiaryContainer,
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.3,
                width: width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(message.msg))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
        ),
      ),
    );
  }
}
