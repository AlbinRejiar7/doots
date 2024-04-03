import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/contacts_screen/contacts_stream_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectGroupMembers extends StatelessWidget {
  final bool isUpdatingMembers;
  final String? groupId;
  final List<String>? currentMembers;
  const SelectGroupMembers(
      {super.key,
      required this.isUpdatingMembers,
      this.currentMembers,
      this.groupId});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Members",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline_sharp),
          onPressed: () {
            if (isUpdatingMembers && c.selectedMembers.isNotEmpty) {
              ChatService.addNewMembersToGroup(
                  groupId!, c.selectedMembers, currentMembers!);

              Get.back();
            } else {
              Get.back();
            }
          }),
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          c.selectedMembers.clear();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.03, width * 0.04, width * 0.03, 0),
            child: Column(
              children: [
                CustomTextField(
                    onChanged: (query) => c.runfilter(query),
                    suffixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    hintText: "Search Contacts.."),
                kHeight(height * 0.01),
                Obx(() {
                  return SizedBox(
                    height: height * 0.031,
                    child: ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: c.selectedMembers.length,
                      itemBuilder: (BuildContext context, int index) {
                        var revList = c.selectedMembers.reversed.toList();
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.02),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                revList[index].name ?? "null",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              kWidth(width * 0.01),
                              GestureDetector(
                                  onTap: () {
                                    c.selectedMembers.removeAt(index);
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        size: width * 0.05,
                                        Icons.close,
                                        color: kWhite,
                                      )))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
                ContactsStreamBuilder(
                  c: c,
                  height: height,
                  width: width,
                  isSelectingForgroups: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
