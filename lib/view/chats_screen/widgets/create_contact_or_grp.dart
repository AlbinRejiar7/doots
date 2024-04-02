import 'package:doots/constants/color_constants.dart';
import 'package:doots/view/chats_screen/create_group.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> createContactOrGroup(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Text(
            "Please select your Option",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          CloseButton(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: kgreen1),
              onPressed: () {
                Get.to(() => CreateContactPage(),
                    transition: Transition.downToUp);
              },
              icon: Icon(
                Icons.contact_page,
                color: kWhite,
              ),
              label: Text(
                "Add Contacts",
                style: TextStyle(color: kWhite),
              )),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: kgreen1),
              onPressed: () {
                Get.to(() => CreateNewGroup(), transition: Transition.downToUp);
              },
              icon: Icon(
                Icons.group_outlined,
                color: kWhite,
              ),
              label: Text(
                "Create Group",
                style: TextStyle(color: kWhite),
              ))
        ],
      ),
    ),
  );
}
