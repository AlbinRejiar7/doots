// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateContactWidget extends StatelessWidget {
  const CreateContactWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
              color: kgreen1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Create Contact",
                      color: kWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    CloseButton(),
                  ],
                ),
              ),
            ),
            Container(
              height: height * 0.44,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.03),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            kHeight(height * 0.01),
                            CustomTextField(
                              hintText: 'Enter Email',
                              isBoarder: false,
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                        kHeight(height * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            kHeight(height * 0.01),
                            CustomTextField(
                              controller: c.nameCtr,
                              hintText: 'Enter name',
                              isBoarder: false,
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                        kHeight(height * 0.01),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: width * 0.03, top: height * 0.03),
                        child: SizedBox(
                          width: width * 0.23,
                          child: CustomAuthButton(
                            title: "Invite",
                            onTap: () {
                              c.addNamesTolist(c.nameCtr.text);
                              c.nameCtr.clear();
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
