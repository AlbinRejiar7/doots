import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chats_screen/select_group_members.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewGroup extends StatelessWidget {
  const CreateNewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var c = Get.put(ChattingScreenController());
    var contactCtr = Get.put(ContactScreenController());
    var gallaryCtr = Get.put(GallaryController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen1,
        centerTitle: true,
        title: const CustomTextWidget(
          text: "Create New Group",
          color: kWhite,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Group Name",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              kHeight(height * 0.01),
              CustomTextField(
                  controller: c.groupNameCtr,
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  isBoarder: false,
                  hintText: "Enter group name"),
              kHeight(height * 0.02),
              Text(
                "Group Profile",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              kHeight(height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          gallaryCtr.openGalleryPicker();
                        },
                        child: Text(
                          "Choose Picture",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: kWhite, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Obx(() {
                    return gallaryCtr.selectedImage.value != null
                        ? CircleAvatar(
                            radius: width * 0.1,
                            backgroundImage:
                                FileImage(gallaryCtr.selectedImage.value!))
                        : CircleAvatar(
                            radius: width * 0.1,
                            backgroundImage: const AssetImage(
                                "assets/images/icons/nodp.png"),
                          );
                  })
                ],
              ),
              kHeight(height * 0.02),
              Text(
                "Group Members",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              kHeight(height * 0.01),
              SizedBox(
                width: width * 0.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Get.to(
                          () => SelectGroupMembers(
                                isUpdatingMembers: false,
                              ),
                          transition: Transition.downToUp);
                    },
                    child: Text(
                      "Select members",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    )),
              ),
              Obx(() {
                return SizedBox(
                  height: height * 0.05,
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: contactCtr.selectedMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      var revList =
                          contactCtr.selectedMembers.reversed.toList();
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: SizedBox(
                          width: height * 0.09,
                          child: Card(
                            color: kgreen1,
                            child: Center(
                              child: Text(
                                revList[index].name ?? "null",
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              kHeight(height * 0.02),
              Text(
                "Description",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              kHeight(height * 0.02),
              CustomTextField(
                  controller: c.descriptionCtr,
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  isBoarder: false,
                  hintText: "Enter Description"),
              kHeight(height * 0.25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return c.isGroupCreating.value
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : SizedBox(
                            width: width * 0.5,
                            height: height * 0.06,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  c.isGroupCreating(true);
                                  if (c.groupNameCtr.text.isNotEmpty &&
                                      c.descriptionCtr.text.isNotEmpty) {
                                    List<String> memberIds = [];
                                    if (contactCtr.selectedMembers.isNotEmpty) {
                                      contactCtr.selectedMembers
                                          .forEach((members) {
                                        memberIds.add(members.id!);
                                      });
                                    }

                                    ChatService.createGroup(
                                      c.groupNameCtr.text,
                                      c.descriptionCtr.text,
                                      memberIds,
                                      gallaryCtr.selectedImage.value,
                                    ).then((value) => c.isGroupCreating(false));
                                  }
                                },
                                child: Text(
                                  "Create",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold),
                                )),
                          );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
