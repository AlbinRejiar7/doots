import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/group_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/widget/details_screen_widget/build_box.dart';
import 'package:doots/view/chating_screen/widget/pop_up_menu_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  final ChatUser chatUser;
  final String? photoImage;
  const DetailsScreen({super.key, required this.chatUser, this.photoImage});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ChattingScreenController());
    var docCtr = Get.put(DocumentController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(photoImage!)),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        color: kWhite,
                      ),
                      ChatPopupMenu(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatUser.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  shadows: [
                                const Shadow(
                                    color: Colors.black, blurRadius: 20)
                              ],
                                  color: kWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STATUS :",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(chatUser.about ?? "loading",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  kHeight(height * 0.01),
                  Text(
                    "INFO :",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name",
                              style: Theme.of(context).textTheme.bodyLarge),
                          CircleAvatar(
                              backgroundColor: kGreen.withOpacity(0.15),
                              child: IconButton(
                                onPressed: () {
                                  c.changeEditingState();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: kgreen1,
                                  size: 15,
                                ),
                              ))
                        ],
                      ),
                      Obx(() {
                        return Visibility(
                          visible: c.isEditing.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText: "Enter name",
                                  isBoarder: false,
                                  fillColor: Theme.of(context).primaryColor,
                                  filled: true,
                                ),
                              ),
                              kWidth(width * 0.01),
                              ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.save_alt,
                                    color: kgreen1,
                                  ),
                                  label: const Text(
                                    "Save",
                                  ))
                            ],
                          ),
                        );
                      }),
                      kHeight(height * 0.01),
                      Text(
                        chatUser.name.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      kHeight(height * 0.01),
                      Text("Email",
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        chatUser.email.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      kHeight(height * 0.01),
                      Text("GROUP IN COMMON",
                          style: Theme.of(context).textTheme.bodyLarge),
                      kHeight(height * 0.01),
                      StreamBuilder(
                          stream: ChatService.getMyUserData(),
                          builder: (context, snapshot) {
                            var myData = snapshot.data;
                            if (myData != null) {
                              List<String> commonGroupsId = myData.groupIds
                                  .toSet()
                                  .intersection(chatUser.groupIds.toSet())
                                  .toList();

                              return StreamBuilder(
                                  stream: ChatService.getCommonGroups(
                                      commonGroupsId),
                                  builder: (context, snapshot) {
                                    List<GroupChat> groupsInfo = [];
                                    if (snapshot.data != null) {
                                      var data = snapshot.data;
                                      if (data != null) {
                                        var datas = data.docs;
                                        groupsInfo = datas
                                            .map((e) =>
                                                GroupChat.fromJson(e.data()))
                                            .toList();
                                      }
                                    } else {
                                      return Text("loading..");
                                    }

                                    if (groupsInfo.isNotEmpty) {
                                      return ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          thickness: 0.3,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: groupsInfo.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius: width * 0.06,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        groupsInfo[index]
                                                            .photoUrl!),
                                              ),
                                              kWidth(width * 0.03),
                                              Text(groupsInfo[index].groupName)
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      return Text("No Group in Common");
                                    }
                                  });
                            }
                            return Text("loading..");
                          }),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      kHeight(height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MEDIA",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Show all",
                                style: TextStyle(color: kgreen1),
                              ))
                        ],
                      ),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: height * 0.02,
                            crossAxisSpacing: width * 0.02),
                        itemCount: c.chats.length > 12 ? 12 : c.chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isUser =
                              (c.chats[index].fromId == ChatService.user.uid);
                          if (c.chats[index].messageType != "text") {
                            return buildMessageWidget(
                                c.chats[index], height, width, docCtr, isUser);
                          }
                          return null;
                        },
                      ),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
