// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/color_constants.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contacts",
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
                  onChanged: (query) => c.runfilter(query),
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  isBoarder: false,
                  hintText: "Search Contacts.."),
              Expanded(
                child: Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: ListView.builder(
                      itemCount: c.foundedUsers.length,
                      itemBuilder: (context, index) {
                        c.contacts.sort((a, b) {
                          return a.toLowerCase().compareTo(b.toLowerCase());
                        });
                        if (index == 0 ||
                            c.foundedUsers[index][0] !=
                                c.foundedUsers[index - 1][0]) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                onTap: () {
                                  Get.to(() => ChattingScreen());
                                },
                                leading: CircleAvatar(),
                                title: Text(c.foundedUsers[index]),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: kGreen,
                                    )),
                              ),
                            ],
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              Get.to(() => ChattingScreen());
                            },
                            leading: CircleAvatar(),
                            title: Text(c.foundedUsers[index]),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert,
                                  color: kGreen,
                                )),
                          );
                        }
                      },
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
