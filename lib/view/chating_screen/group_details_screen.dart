import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/group_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/widget/pop_up_menu_widget.dart';
import 'package:doots/view/chats_screen/select_group_members.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GroupDetailsScreen extends StatelessWidget {
  final GroupChat groupChatInfo;
  const GroupDetailsScreen({super.key, required this.groupChatInfo});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ChattingScreenController());
    var height = context.height;
    var width = context.width;
    List<ChatUser> groupMembersInfo = [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(groupChatInfo.photoUrl!)),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          groupChatInfo.groupName,
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
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Description :   ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(groupChatInfo.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Group Name :",
                              style: Theme.of(context).textTheme.bodyLarge),
                          kWidth(width * 0.02),
                          Text(
                            groupChatInfo.groupName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          const Spacer(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Members",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          CircleAvatar(
                              backgroundColor: kGreen.withOpacity(0.15),
                              child: IconButton(
                                onPressed: () {
                                  if (groupChatInfo.adminId ==
                                      ChatService.user.uid) {
                                    Get.to(
                                        () => SelectGroupMembers(
                                              isUpdatingMembers: true,
                                              currentMembers:
                                                  groupChatInfo.membersId,
                                              groupId: groupChatInfo.groupId,
                                            ),
                                        transition: Transition.downToUp);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only Group Admin Can Add Members");
                                  }
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: kgreen1,
                                  size: 15,
                                ),
                              ))
                        ],
                      ),
                      kHeight(height * 0.01),
                      StreamBuilder(
                          stream:
                              ChatService.getAllUsers(groupChatInfo.membersId),
                          builder: (context, snapshot) {
                            var data = snapshot.data?.docs;
                            if (data != null) {
                              groupMembersInfo.addAll(data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .where((chatuser) =>
                                          !groupMembersInfo.any(
                                              (chat) => chat.id == chatuser.id))
                                      .toList() ??
                                  []);
                            }
                            if (groupMembersInfo.isNotEmpty) {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  thickness: 0.2,
                                ),
                                shrinkWrap: true,
                                itemCount: groupMembersInfo.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(() => ChattingScreen(
                                          chatUser: groupMembersInfo[index]));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(width * 0.016),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: width * 0.07,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    groupMembersInfo[index]
                                                        .image!),
                                          ),
                                          kWidth(width * 0.03),
                                          Text(groupMembersInfo[index].name!),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    surfaceTintColor:
                                                        Colors.transparent,
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    title: Text(
                                                      "Do you want to remove this member ? ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            ChatService.removeMemberFromGroup(
                                                                groupChatInfo
                                                                    .groupId,
                                                                groupMembersInfo[
                                                                        index]
                                                                    .id!,
                                                                groupChatInfo
                                                                    .adminId);
                                                          },
                                                          child: Text("Yes")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("No"))
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Text("Loading...");
                            }
                          }),
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
