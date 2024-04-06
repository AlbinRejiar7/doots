import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/details_screen_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/group_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/view/chating_screen/media_show_all_screen.dart';
import 'package:doots/view/chating_screen/widget/details_screen_widget/media_grid_view_widget.dart';
import 'package:doots/view/chating_screen/widget/pop_up_menu_widget.dart';
import 'package:doots/view/chats_screen/select_group_members.dart';
import 'package:doots/view/home/home_page.dart';
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
    var ctr = Get.put(GroupDetailsScreenController());

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
                              ChatService.getGroupInfo(groupChatInfo.groupId),
                          builder: (context, snapshot) {
                            var data = snapshot.data?.data();
                            GroupChat groupChatdetails;
                            if (data != null) {
                              groupChatdetails = GroupChat.fromJson(data);
                            } else {
                              return CircularProgressIndicator();
                            }

                            return GetBuilder<GroupDetailsScreenController>(
                                builder: (_) {
                              print(groupChatdetails.membersId.toString() +
                                  "groupchatmembers");
                              return StreamBuilder(
                                  stream: ChatService.getAllUsers(
                                      groupChatdetails.membersId),
                                  builder: (context, snapshot) {
                                    var data = snapshot.data?.docs;
                                    if (data != null) {
                                      ctr.groupMembersInfo.addAll(data
                                              ?.map((e) =>
                                                  ChatUser.fromJson(e.data()))
                                              .where((chatuser) => !ctr
                                                  .groupMembersInfo
                                                  .any((chat) =>
                                                      chat.id == chatuser.id))
                                              .toList() ??
                                          []);
                                    }
                                    if (ctr.groupMembersInfo.isNotEmpty) {
                                      return ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                          thickness: 0.2,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: ctr.groupMembersInfo.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => ChattingScreen(
                                                  chatUser:
                                                      ctr.groupMembersInfo[
                                                          index]));
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 0.016),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: width * 0.07,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            ctr
                                                                .groupMembersInfo[
                                                                    index]
                                                                .image!),
                                                  ),
                                                  kWidth(width * 0.03),
                                                  Text(ctr
                                                      .groupMembersInfo[index]
                                                      .name!),
                                                  const Spacer(),
                                                  ctr.groupMembersInfo[index]
                                                              .id ==
                                                          groupChatdetails
                                                              .adminId
                                                      ? const IconButton(
                                                          onPressed: null,
                                                          icon: Icon(
                                                            Icons
                                                                .admin_panel_settings,
                                                            color: kgreen1,
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            showDialogeWidget(
                                                                context:
                                                                    context,
                                                                onPressedTick:
                                                                    () {
                                                                  ctr.removeMemberFromGroup(
                                                                      groupChatInfo
                                                                          .groupId,
                                                                      ctr
                                                                          .groupMembersInfo[
                                                                              index]
                                                                          .id!,
                                                                      groupChatInfo
                                                                          .adminId);

                                                                  Get.back();
                                                                },
                                                                title:
                                                                    "Do u want remove this person ?");
                                                          },
                                                          icon: const Icon(
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
                                  });
                            });
                          }),
                      kHeight(height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MEDIAS",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(() => ShowAllMediaScreen());
                              },
                              child: const Text(
                                "Show all",
                                style: TextStyle(color: kgreen1),
                              ))
                        ],
                      ),
                      MediaGridViewWidget(
                        isFullScreen: false,
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
      floatingActionButton: FloatingActionButton.extended(
          tooltip: "Leave group",
          backgroundColor: const Color.fromARGB(255, 255, 31, 31),
          onPressed: () => showDialogeWidget(
              context: context,
              onPressedTick: () =>
                  onPressedLeaveGroup(groupInfo: groupChatInfo),
              title: "Do u want to leave from this group ?"),
          label: Icon(Icons.logout)),
    );
  }

  Future<dynamic> showDialogeWidget({
    required BuildContext context,
    required void Function()? onPressedTick,
    required String title,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(onPressed: onPressedTick, child: Text("Yes")),
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("No"))
        ],
      ),
    );
  }

  void onPressedLeaveGroup({
    required GroupChat groupInfo,
  }) async {
    try {
      bool isAdmin = (groupInfo.adminId == ChatService.user.uid);

      DocumentReference groupRef =
          ChatService.firestore.collection('groups').doc(groupInfo.groupId);
      await groupRef.update({
        'membersId': FieldValue.arrayRemove([ChatService.user.uid]),
      }).then((_) {
        Fluttertoast.showToast(msg: 'Successfully leaved from group');
      }).catchError((error) {
        Fluttertoast.showToast(msg: 'Failed to Leave: $error');
      });

      await ChatService.firestore
          .collection("users")
          .doc(ChatService.user.uid)
          .update({
            "groupIds": FieldValue.arrayRemove([groupInfo.groupId])
          })
          .then((_) {})
          .catchError((error) {
            Fluttertoast.showToast(msg: 'Failed to Leave: $error');
          });
      if (isAdmin) {
        List<String> groupMembersId = await getMemberIds(groupInfo.groupId);
        final random = Random();
        List<String> filteredList = groupMembersId
            .where((item) => item != ChatService.user.uid)
            .toList();

        if (filteredList.isEmpty) {
          throw Exception(
              'Excluded string represents all elements in the list');
        }
        int randomIndex = random.nextInt(filteredList.length);
        await groupRef.update({
          'adminId': filteredList[randomIndex],
        }).then((_) {
          Fluttertoast.showToast(msg: 'Successfully leaved from group');
        }).catchError((error) {
          Fluttertoast.showToast(msg: 'Failed to Leave: $error');
        });
      }
      Get.offAll(() => const HomeScreen());
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}

Future<List<String>> getMemberIds(String groupId) async {
  var collection = ChatService.firestore.collection("groups").doc(groupId);
  final querySnapshot = await collection.get();

  final data = querySnapshot.data();
  if (data != null) {
    // Ensure that the 'membersId' field is List<dynamic>
    final List<dynamic> memberIdsDynamic = data['membersId'];

    // Convert each element to String based on its type
    final List<String> memberIds = [];
    for (var memberId in memberIdsDynamic) {
      if (memberId is String) {
        memberIds.add(memberId);
      } else if (memberId is int || memberId is double) {
        memberIds.add(memberId.toString());
      }
      // Add more conditions as needed for other types
    }

    return memberIds;
  }
  return [];
}
