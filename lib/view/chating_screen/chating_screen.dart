import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/service/convert_to_date_time.dart';
import 'package:doots/view/chating_screen/user_details_screen.dart';
import 'package:doots/widgets/chatting_screen_widgets/audio_player_widget.dart';
import 'package:doots/widgets/chatting_screen_widgets/chat_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/custom_bottom_sheet.dart';
import 'package:doots/widgets/chatting_screen_widgets/document_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/mic_send_button_widget.dart';
import 'package:doots/widgets/chatting_screen_widgets/photo_bubble.dart';
import 'package:doots/widgets/chatting_screen_widgets/reply_widget.dart';
import 'package:doots/widgets/chatting_screen_widgets/video_bubble.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class ChattingScreen extends StatelessWidget {
  final ChatUser chatUser;
  const ChattingScreen({super.key, required this.chatUser});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var c = Get.put(ChattingScreenController());

    var audioCtr = Get.put(AudioController());

    var gallaryCtr = Get.put(GallaryController());

    bool isSomeoneTyping = false;
    String? photoImage;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      floatingActionButton: Obx(() {
        return Padding(
          padding: EdgeInsets.only(right: width * 0.04, bottom: height * 0.07),
          child: Visibility(
            visible: c.canScrollToOldest.value,
            child: FloatingActionButton(
                backgroundColor: kgreen1,
                shape: CircleBorder(),
                onPressed: () {
                  c.scrollToOldest();
                },
                child: Icon(Icons.arrow_downward)),
          ),
        );
      }),
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 0.1)),
        title: InkWell(
          onTap: () {
            Get.to(() => DetailsScreen(
                  chatUser: chatUser,
                  photoImage: photoImage,
                ));
          },
          child: StreamBuilder(
              stream: ChatService.getUserInfo(chatUser),
              builder: (context, snapshot) {
                List<ChatUser> list = [];
                if (snapshot.data != null) {
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  photoImage = list[0].isPhotoOn != null && list[0].isPhotoOn!
                      ? list[0].image
                      : "https://www.dpforwhatsapp.in/img/no-dp/19.webp";
                }

                return Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: list.isNotEmpty
                            ? CachedNetworkImageProvider(photoImage!)
                            : CachedNetworkImageProvider(chatUser.image!)),
                    kWidth(width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list.isNotEmpty
                              ? list[0].nickName!
                              : chatUser.nickName!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (list.isNotEmpty)
                          if (list[0].isOnline!)
                            StreamBuilder(
                                stream: ChatService.getConversationMetadata(
                                    chatUser),
                                builder: (context, snapshot) {
                                  final data = snapshot.data?.data() ?? {};
                                  isSomeoneTyping = data['userId'] != null &&
                                          data['userId'] != ChatService.user.uid
                                      ? true
                                      : false;

                                  return isSomeoneTyping
                                      ? Text("Typing...",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis))
                                      : Text("Online",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis));
                                }),
                        if (list.isNotEmpty)
                          if (!list[0].isOnline!)
                            list[0].isLastSeenOn ?? true
                                ? Text(
                                    formatMillisecondsSinceEpoch(
                                        int.parse(list[0].lastActive!)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis))
                                : const SizedBox.shrink()
                      ],
                    )
                  ],
                );
              }),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () {
          if (c.isContainerVisibile.value == true) {
            c.changeBottomSheet(false);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: ChatService.getAllMessages(chatUser),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.data != null) {
                      final messageData = snapshot.data!.docs;
                      c.chats = messageData
                          .map((e) => Message.fromJson(e.data()))
                          .toList();
                    }

                    if (c.chats.isNotEmpty) {
                      return ListView.builder(
                          controller: c.scrollController,
                          padding: EdgeInsets.all(width * 0.02),
                          reverse: true,
                          itemCount: c.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (c.chats[index].messageType == 'text') {
                              return SwipeTo(
                                onLeftSwipe: (details) {
                                  c.selectedMessage(c.chats[index]);
                                  c.isReplyWidgetOn(true);
                                  c.focusNode.requestFocus();
                                },
                                onRightSwipe: (details) {
                                  c.selectedMessage(c.chats[index]);
                                  c.isReplyWidgetOn(true);
                                  c.focusNode.requestFocus();
                                },
                                child: ChatBubble(
                                  message: c.chats[index],
                                ),
                              );
                            } else if (c.chats[index].messageType == 'image') {
                              return PhotoBubble(
                                message: c.chats[index],
                              );
                            } else if (c.chats[index].messageType ==
                                'document') {
                              return DocumentBubble(message: c.chats[index]);
                            } else if (c.chats[index].messageType == 'video') {
                              return VideoBubble(
                                message: c.chats[index],
                              );
                            } else if (c.chats[index].messageType == 'audio') {
                              return AudioPlayerWidget(
                                message: c.chats[index],
                              );
                            } else if (c.chats[index].messageType == 'reply') {
                              return ReplyWidget(
                                  chatUserName: "",
                                  chatUser: chatUser,
                                  message: c.chats[index]);
                            } else {
                              return const Text("Some thing wrong here");
                            }
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ),
            Obx(() {
              return gallaryCtr.isUploading.value
                  ? Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink();
            }),
            ReplyMessageWidget(),
            Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                        top: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.1))),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          kWidth(width * 0.03),
                          Expanded(child: Obx(() {
                            return audioCtr.isRecording.value
                                ? GetBuilder<AudioController>(builder: (ctr) {
                                    return Row(
                                      children: [
                                        StreamBuilder(
                                            stream: ctr.recorderController
                                                .onCurrentDuration,
                                            builder: (context, snapshot) {
                                              return Text(
                                                ChatService.formatDuration(
                                                    snapshot.data ??
                                                        const Duration()),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              );
                                            }),
                                        Flexible(
                                          child: AudioWaveforms(
                                            enableGesture: true,
                                            size: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.47,
                                                50),
                                            recorderController:
                                                ctr.recorderController,
                                            waveStyle: const WaveStyle(
                                              waveColor: Colors.white,
                                              extendWaveform: true,
                                              showMiddleLine: false,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: kgreen1,
                                            ),
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                                : CustomTextField(
                                    isChattingScreen: true,
                                    onChanged: (value) {
                                      ChatService.updateIsTypingStatus(
                                          chatUser.id!,
                                          c.chatCtr.text.isNotEmpty);
                                      c.changeMicState(value.isEmpty);
                                    },
                                    focusNode: c.focusNode,
                                    onTap: () {
                                      c.changeBottomSheet(false);
                                    },
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    controller: c.chatCtr,
                                    fillColor: Theme.of(context).primaryColor,
                                    filled: true,
                                    hintText: 'Type your message...',
                                    isBoarder: false,
                                  );
                          })),
                          IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (c.isContainerVisibile.value == true) {
                                  c.changeBottomSheet(false);
                                } else {
                                  c.changeBottomSheet(true);
                                }
                              },
                              icon: Transform.rotate(
                                  angle: 10,
                                  child: const Icon(Icons.attach_file))),
                          MicAndSendButtonWidget(
                              chatUserId: chatUser.id!,
                              groupId: '',
                              c: c,
                              height: height,
                              audioCtr: audioCtr),
                        ],
                      ),
                    ],
                  ),
                )),
            Obx(() {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: c.isContainerVisibile.value ? (height * 0.3) : 0.0,
                child: Center(
                    child: CustomBottomSheet(
                        groupId: '',
                        chatUserId: chatUser.id!,
                        width: width,
                        height: height,
                        title: title,
                        myIcons: myIcons)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;

    return GetBuilder<ChattingScreenController>(builder: (_) {
      var message = _.chosenReplyMessage.value;
      bool isUser = (message.fromId == ChatService.user.uid);
      return AnimatedContainer(
        padding: EdgeInsets.all(width * 0.01),
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
        height: _.isReply.value ? (height * 0.07) : 0.0,
        child: Row(
          children: [
            Container(
              color: isUser ? Colors.blue : Colors.redAccent,
              width: 4,
            ),
            kWidth(width * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    isUser ? "You" : message.name ?? "null",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    _.chosenReplyMessage.value.msg,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
            CloseButton(
              onPressed: () {
                _.isReplyWidgetOn(false);
              },
            )
          ],
        ),
      );
    });
  }
}
