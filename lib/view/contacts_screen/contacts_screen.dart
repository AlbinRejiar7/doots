import 'dart:developer';

import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          padding:
              EdgeInsets.fromLTRB(width * 0.03, width * 0.04, width * 0.03, 0),
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
                      Get.to(() => CreateContactPage(),
                          transition: Transition.downToUp);
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
                  hintText: "Search Contacts.."),
              Expanded(
                child: Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: ListView.builder(
                      itemCount: c.foundedUsers.length,
                      itemBuilder: (context, index) {
                        c.contacts.sort((a, b) {
                          return a['name']
                              .toLowerCase()
                              .compareTo(b['name'].toLowerCase());
                        });
                        if (index == 0 ||
                            c.foundedUsers[index]['name'][0] !=
                                c.foundedUsers[index - 1]['name'][0]) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomTextWidget(
                                    text: c.foundedUsers[index]['name'][0],
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                  c.tappedIndex(index);
                                  log(c.currentIndex.value.toString());
                                  Get.to(
                                    () => ChattingScreen(),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://dpwalay.com/wp-content/uploads/2023/11/dazzling-girl-dp-for-whatsapp.jpg"),
                                ),
                                title: Text(c.foundedUsers[index]['name']),
                                // trailing: IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(
                                //       Icons.more_vert,
                                //       color: kGreen,
                                //     )),
                              ),
                            ],
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              c.tappedIndex(index);
                              Get.to(() => ChattingScreen(),
                                  arguments: c.foundedUsers[index]['name']);
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://dpwalay.com/wp-content/uploads/2023/11/dazzling-girl-dp-for-whatsapp.jpg"),
                            ),
                            title: Text(c.foundedUsers[index]['name']),
                            // trailing: IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(
                            //       Icons.more_vert,
                            //       color: kGreen,
                            //     )),
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
