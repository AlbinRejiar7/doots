import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/downlod_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DocumentBubble extends StatelessWidget {
  final Message message;

  const DocumentBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    var data = GetStorage();

    var width = context.width;
    var height = context.height;
    var c = Get.put(DocumentController());
    var downloadCtr = Get.put(DownloadController());
    bool isUser = (message.fromId == ChatService.user.uid);

    if (!isUser && message.read.isEmpty) {
      ChatService.updateMessageStatus(message);
    }
    String sentTime =
        ChatService.convertTimestampTo12HrTime(int.parse(message.sent));
    return Padding(
      padding: EdgeInsets.all(width * 0.02),
      child: Container(
        margin: isUser
            ? EdgeInsets.only(left: width * 0.4)
            : EdgeInsets.only(right: width * 0.4),
        child: GestureDetector(
          onTap: () async {
            isUser
                ? await c.openFile(message.localFileLocation)
                : await c.openFile(data.read(message.filename));
          },
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        if (isUser)
                          Container(
                            height: height * 0.04,
                            width: height * 0.04,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/icons/document_icon.png"))),
                          ),
                        if (!isUser)
                          message.isDownloaded
                              ? Container(
                                  height: height * 0.04,
                                  width: height * 0.04,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/icons/document_icon.png"))),
                                )
                              : message.isDownloading
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        try {
                                          ChatService.updateDownloadingStatus(
                                              message, true);
                                          await downloadCtr
                                              .downloadFileFromFirebase(
                                                  message.msg,
                                                  message.filename);
                                          await ChatService
                                              .updateDownloadedStatus(
                                                  message, true);
                                          await ChatService
                                              .updateDownloadingStatus(
                                                  message, false);
                                        } on Exception catch (e) {
                                          Get.snackbar("title", e.toString());
                                        }
                                      },
                                      icon: const Icon(Icons.download)),
                        kWidth(width * 0.02),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message.filename,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Row(
                                children: [
                                  Text(message.size,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  kWidth(width * 0.01),
                                  Text("•",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  kWidth(width * 0.01),
                                  Flexible(
                                    child: Text(message.ext,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(sentTime,
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
            ],
          ),
        ),
      ),
    );
  }
}
