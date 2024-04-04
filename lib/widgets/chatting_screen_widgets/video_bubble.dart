import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/download_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class VideoBubble extends StatelessWidget {
  final Message message;
  final String? groupId;
  const VideoBubble({
    super.key,
    required this.message,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    var total = width + height;

    bool isUser = (message.fromId == ChatService.user.uid);
    var c = Get.put(DownloadController());

    if (!isUser && message.read.isEmpty) {
      ChatService.updateMessageStatus(message);
    }
    Future<void> downloadVideo() async {
      if (groupId != null) {
        ChatService.updateDownloadingStatusForGroup(message, true, groupId!);
        await c.downloadVideoFromFirebase(message.msg, message.filename);
        ChatService.updateDownloadedStatusForGroup(message, true, groupId!);
        ChatService.updateDownloadingStatusForGroup(message, false, groupId!);
      } else {
        ChatService.updateDownloadingStatus(message, true);
        await c.downloadVideoFromFirebase(message.msg, message.filename);
        ChatService.updateDownloadedStatus(message, true);
        ChatService.updateDownloadingStatus(message, false);
      }
    }

    return GestureDetector(
      onTap: () {
        if (isUser) {
          Get.to(
              () => VideoGallery(
                    isUser: isUser,
                    message: message,
                  ),
              transition: Transition.cupertino);
        } else {
          if (message.isDownloaded) {
            Get.to(
                () => VideoGallery(
                      isUser: isUser,
                      message: message,
                    ),
                transition: Transition.cupertino);
          } else {
            Fluttertoast.showToast(
                msg: "Please Download the video",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.all(total * 0.01),
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
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.3,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                message.thumbnailPath))),
                  ),
                  Positioned(
                      bottom: 1,
                      left: 1,
                      right: 1,
                      top: 1,
                      child: Image.asset(
                          color: kgreen1,
                          scale: width * 0.02,
                          "assets/images/icons/play.png")),
                  if (!isUser)
                    message.isDownloaded
                        ? const SizedBox.shrink()
                        : message.isDownloading
                            ? Positioned(
                                bottom: 10,
                                left: 10,
                                child: SizedBox(
                                  height: height * 0.035,
                                  width: height * 0.035,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: kgreen1,
                                  ),
                                ),
                              )
                            : Positioned(
                                bottom: 1,
                                child: IconButton(
                                    onPressed: () async {
                                      downloadVideo();
                                    },
                                    icon: CircleAvatar(
                                        radius: width * 0.04,
                                        backgroundColor: kgreen1,
                                        child: Icon(
                                          size: width * 0.04,
                                          Icons.download,
                                          color: kWhite,
                                        ))),
                              )
                ],
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
