import 'dart:io';

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewScreen extends StatelessWidget {
  final String? size;
  final String chatUserID;
  final String groupId;
  const PreviewScreen(
      {super.key,
      required this.size,
      required this.chatUserID,
      required this.groupId});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(DocumentController());

    var width = Get.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(
          onPressed: () {
            c.selectedFile.value = null;

            Get.back();
          },
        ),
        title: Text(c.selectedFile.value!.name),
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            c.selectedFile.value = null;
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(width * 0.07),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        c.selectedFile.value!.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 25),
                      ),
                      Text(
                        size ?? "null",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() {
                      return c.isDocumentUploading.value
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: kgreen1),
                              onPressed: () async {
                                if (c.selectedFile.value != null) {
                                  c.changeUploadingState(true);
                                  await ChatService.sendDocuments(
                                          localPath:
                                              c.selectedFile.value!.path!,
                                          chatUserId: chatUserID,
                                          groupId: groupId,
                                          file:
                                              File(c.selectedFile.value!.path!),
                                          type: 'document',
                                          fileName: c.selectedFile.value!.name,
                                          fileSize: size!,
                                          ext: c.selectedFile.value!.extension!)
                                      .then((value) =>
                                          c.changeUploadingState(false));
                                  c.selectedFile.value = null;

                                  Get.back();
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: kWhite,
                              ));
                    })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
