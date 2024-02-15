// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool isListVisible = false;
  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  plusCardButton(
                    height,
                    () {
                      Get.dialog(CreateContactWidget());
                    },
                  )
                ],
              ),
              kHeight(height * 0.03),
              CustomTextField(
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  isBoarder: false,
                  hintText: "Search here.."),
              kHeight(height * 0.03),
              Text(
                "FAVORITE",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              kHeight(height * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DIRECT MESSAGES",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  plusCardButton(height, () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            titlePadding: EdgeInsets.all(0),
                            contentPadding: EdgeInsets.all(8),
                            title: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: kgreen1,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextWidget(
                                        fontSize: 17,
                                        text: "Create Contact",
                                        color: kWhite,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      CloseButton(),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                          suffixIcon: Icon(Icons.search),
                                          filled: true,
                                          fillColor:
                                              Theme.of(context).primaryColor,
                                          isBoarder: false,
                                          hintText: "Search here.."),
                                      kHeight(height * 0.02),
                                      Text(
                                        "CONTACTS",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount: c.foundedUsers.length,
                                itemBuilder: (context, index) {
                                  c.contacts.sort((a, b) {
                                    return a
                                        .toLowerCase()
                                        .compareTo(b.toLowerCase());
                                  });
                                  if (index == 0 ||
                                      c.foundedUsers[index][0] !=
                                          c.foundedUsers[index - 1][0]) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CustomTextWidget(
                                              text: c.foundedUsers[index][0],
                                              color: kGreen,
                                            ),
                                            kWidth(width * 0.02),
                                            Expanded(
                                                child: Divider(
                                              thickness: 0,
                                            )),
                                          ],
                                        ),
                                        ListTile(
                                          leading: Checkbox(
                                              activeColor: kgreen1,
                                              value: true,
                                              onChanged: (v) {}),
                                          title: Text(c.foundedUsers[index]),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return ListTile(
                                      leading: Checkbox(
                                          activeColor: kgreen1,
                                          value: true,
                                          onChanged: (v) {}),
                                      title: Text(c.foundedUsers[index]),
                                    );
                                  }
                                },
                              ),
                            ),
                            actions: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  width: width * 0.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: kgreen1),
                                  child: Center(
                                      child: Icon(
                                    Icons.send,
                                    color: kWhite,
                                  )),
                                ),
                              )
                            ],
                          );
                        });
                  })
                ],
              ),
              kHeight(height * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CHANNELS",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  plusCardButton(height, () {
                    newMethod(context, height);
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<dynamic> newMethod(BuildContext context, double height) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(8),
            title: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: kgreen1,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    text: "Create New Group",
                    color: kWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                  CloseButton(),
                ],
              ),
            ),
            content: SingleChildScrollView(
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
                      suffixIcon: Icon(Icons.search),
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
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {},
                          child: Text(
                            "Choose file",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                      Text(
                        "No file\nchoosen",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  kHeight(height * 0.02),
                  Text(
                    "Group Name",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Text(
                        "Select Member",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                  Text(
                    "Description",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  kHeight(height * 0.02),
                  CustomTextField(
                      isMaxLine: true,
                      maxLines: 3,
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      isBoarder: false,
                      hintText: "Enter Description"),
                  kHeight(height * 0.02),
                ],
              ),
            ),
            actions: [CustomAuthButton(title: "Create Group")],
          );
        });
  }
}
