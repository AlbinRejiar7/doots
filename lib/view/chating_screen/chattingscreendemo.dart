// import 'dart:io';

// import 'package:doots/controller/audio_controller.dart';
// import 'package:doots/controller/bottom_sheet_controller/camera_controller.dart';
// import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
// import 'package:doots/controller/bottom_sheet_controller/icons.dart';
// import 'package:doots/controller/chatting_screen_controller.dart';
// import 'package:doots/controller/contact_screen_controller.dart';
// import 'package:doots/controller/downlod_controller.dart';
// import 'package:doots/view/chating_screen/user_details_screen.dart';
// import 'package:doots/widgets/chatting_screen_widgets/audio_doc_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/chat_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/custom_bottom_sheet.dart';
// import 'package:doots/widgets/chatting_screen_widgets/document_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/location_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/mic_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/mic_send_button_widget.dart';
// import 'package:doots/widgets/chatting_screen_widgets/photo_bubble.dart';
// import 'package:doots/widgets/chatting_screen_widgets/video_bubble.dart';
// import 'package:doots/widgets/sizedboxwidget.dart';
// import 'package:doots/widgets/text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChattingScreen extends StatelessWidget {
//   const ChattingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var height = context.height;
//     var width = context.width;
//     var c = Get.put(ChattingScreenController());
//     var contactctr = Get.put(ContactScreenController());
//     var audioCtr = Get.put(AudioController());
//     var documentCtr = Get.put(DocumentController());

//     Future<File> convertFileToFutureFile(String filePath) async {
//       File file = File(filePath);

//       return file;
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         shape: Border(
//             bottom: BorderSide(
//                 color: Theme.of(context).colorScheme.secondary, width: 0.1)),
//         title: InkWell(
//           onTap: () {
//             Get.to(() => const DetailsScreen());
//           },
//           child: Row(
//             children: [
//               const CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg'),
//               ),
//               kWidth(width * 0.02),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text(
//                   //   "${contactctr.foundedUsers[contactctr.currentIndex.value]['name']}",
//                   //   style: Theme.of(context)
//                   //       .textTheme
//                   //       .bodyLarge
//                   //       ?.copyWith(fontWeight: FontWeight.bold),
//                   // ),
//                   Text("last seen 7-2-2023, 2:22 pm",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           fontSize: 12, overflow: TextOverflow.ellipsis)),
//                 ],
//               )
//             ],
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.search,
//                 color: Theme.of(context).iconTheme.color,
//               )),
//         ],
//       ),
//       // ignore: deprecated_member_use
//       body: WillPopScope(
//         onWillPop: () {
//           if (c.isContainerVisibile.value == true) {
//             c.changeBottomSheet(false);
//             return Future.value(false);
//           } else {
//             return Future.value(true);
//           }
//         },
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Column(
//             children: [
//               TextButton(
//                   onPressed: () {
//                     DownloadController().downloadVideo();
//                   },
//                   child: const Text("download this url")),
//               Obx(() {
//                 List chats = [];
//                 chats.addAll(c.chats.reversed);
//                 return Flexible(
//                   child: ListView.builder(
//                     reverse: true,
//                     itemCount: chats.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (chats[index]['type'] == MessageType.text) {
//                         return ChatBubble(
//                           width: width,
//                           chats: chats,
//                           index: index,
//                         );
//                       } else if (chats[index]['type'] == MessageType.document) {
//                         return chats[index]['chats'] != null
//                             ? DocumentBubble(
//                                 width: width,
//                                 documentCtr: documentCtr,
//                                 chats: chats,
//                                 height: height,
//                                 index: index,
//                               )
//                             : const SizedBox.shrink();
//                       } else if (chats[index]['type'] == MessageType.photos) {
//                         return PhotoBubble(
//                           chats: chats[index]['chats'],
//                           image: chats[index]['chats'][0],
//                           height: height,
//                           width: width,
//                           index: index,
//                         );
//                       } else if (chats[index]['type'] == MessageType.videos) {
//                         return VideoBubble(
//                           chats: chats,
//                           width: width,
//                           height: height,
//                           index: index,
//                         );
//                       } else if (chats[index]['type'] == MessageType.location) {
//                         return LocationBubble(
//                             index: index,
//                             chats: chats,
//                             width: width,
//                             height: height);
//                       } else if (chats[index]['type'] ==
//                           MessageType.audioDocument) {
//                         return audioDocBubble(width, convertFileToFutureFile,
//                             chats, index, context);
//                       } else if (chats[index]['type'] ==
//                           MessageType.capturePhoto) {
//                         return cameraPhotoBubble(
//                             height, width, context, chats[index]['chats']);
//                       } else {
//                         return Obx(() {
//                           return audioCtr.isMicrophoneGranted.value
//                               ? MicBubble(
//                                   width: width,
//                                   chats: chats,
//                                   index: index,
//                                 )
//                               : const SizedBox();
//                         });
//                       }
//                     },
//                   ),
//                 );
//               }),
//               Container(
//                   width: width,
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       border: Border(
//                           top: BorderSide(
//                               color: Theme.of(context).colorScheme.secondary,
//                               width: 0.1))),
//                   child: Padding(
//                     padding: EdgeInsets.all(width * 0.02),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             kWidth(width * 0.03),
//                             Expanded(child: Obx(() {
//                               return CustomTextField(
//                                 isChattingScreen: true,
//                                 onChanged: (value) {
//                                   if (c.chatCtr.text.isEmpty) {
//                                     c.changeMicState(true);
//                                   } else {
//                                     c.changeMicState(false);
//                                   }
//                                 },
//                                 focusNode: c.focusNode,
//                                 onTap: () {
//                                   c.changeBottomSheet(false);
//                                 },
//                                 style: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.primary),
//                                 controller: c.chatCtr,
//                                 fillColor: Theme.of(context).primaryColor,
//                                 filled: true,
//                                 hintText: audioCtr.isRecording.value
//                                     ? "RECORDING>>>>>>>"
//                                     : 'Type your message...',
//                                 isBoarder: false,
//                               );
//                             })),
//                             IconButton(
//                                 onPressed: () {
//                                   FocusScope.of(context).unfocus();
//                                   if (c.isContainerVisibile.value == true) {
//                                     c.changeBottomSheet(false);
//                                   } else {
//                                     c.changeBottomSheet(true);
//                                   }
//                                 },
//                                 icon: Transform.rotate(
//                                     angle: 10,
//                                     child: const Icon(Icons.attach_file))),
//                             MicAndSendButtonWidget(
//                                 c: c, height: height, audioCtr: audioCtr),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )),
//               Obx(() {
//                 return AnimatedContainer(
//                   duration: Duration(milliseconds: 400),
//                   curve: Curves.easeInOut,
//                   height: c.isContainerVisibile.value ? (height * 0.3) : 0.0,
//                   child: Center(
//                       child: CustomBottomSheet(
//                           width: width,
//                           height: height,
//                           title: title,
//                           myIcons: myIcons)),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
