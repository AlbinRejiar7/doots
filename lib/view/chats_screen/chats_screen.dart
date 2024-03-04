import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_group.dart';
import 'direct_message.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

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
                      Get.to(() => CreateContactPage(),
                          transition: Transition.downToUp);
                    },
                  )
                ],
              ),
              kHeight(height * 0.03),
              CustomTextField(
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  prefix: Icon(Icons.search),
                  hintText: "Search here.."),
              kHeight(height * 0.03),
              Text(
                "FAVORITE",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: c.foundedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  if (c.foundedUsers[index]['isFav'].value) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://instacaptionsforall.in/wp-content/uploads/2023/12/50-5.jpg"),
                      ),
                      title: Text(c.foundedUsers[index]['name']),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DIRECT MESSAGES",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  plusCardButton(height, () {
                    Get.to(() => DirectMessages(),
                        transition: Transition.downToUp);
                  })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CHANNELS",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  plusCardButton(height, () {
                    Get.to(() => CreateNewGroup(),
                        transition: Transition.downToUp);
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
