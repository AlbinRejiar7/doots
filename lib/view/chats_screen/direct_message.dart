import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DirectMessages extends StatelessWidget {
  const DirectMessages({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen1,
        title: const CustomTextWidget(
          text: "Contacts",
          color: kWhite,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(width * 0.06, height * 0.04, width * 0.08, 0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                    prefix: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    isBoarder: false,
                    hintText: "Search here.."),
                kHeight(height * 0.02),
                Text(
                  "CONTACTS",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: c.foundedUsers.length,
                itemBuilder: (context, index) {
                  c.contacts.sort((a, b) {
                    if (a['isFav'].value == b['isFav'].value) {
                      return a['name']
                          .toLowerCase()
                          .compareTo(b['name'].toLowerCase());
                    } else {
                      return a['isFav'].value ? 1 : -1;
                    }
                  });

                  if (index == 0 ||
                      c.foundedUsers[index]['name'][0] !=
                          c.foundedUsers[index - 1]['name'][0]) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: Row(
                            children: [
                              CustomTextWidget(
                                text: c.foundedUsers[index]['name'][0],
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const Expanded(
                                  child: Divider(
                                thickness: 0,
                              )),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GetBuilder<ContactScreenController>(builder: (c) {
                              return Checkbox(
                                  shape: const CircleBorder(),
                                  activeColor: kgreen1,
                                  value: c.foundedUsers[index]['isChecked'],
                                  onChanged: (v) {
                                    c.changeIsCheckedState(index);
                                  });
                            }),
                            Text(c.foundedUsers[index]['name'])
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        GetBuilder<ContactScreenController>(builder: (c) {
                          return Checkbox(
                              shape: const CircleBorder(),
                              activeColor: kgreen1,
                              value: c.foundedUsers[index]['isChecked'],
                              onChanged: (v) {
                                c.changeIsCheckedState(index);
                              });
                        }),
                        Text(c.foundedUsers[index]['name'])
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
