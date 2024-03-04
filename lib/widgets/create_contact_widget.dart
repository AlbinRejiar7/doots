import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateContactPage extends StatelessWidget {
  const CreateContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen1,
        title: CustomTextWidget(
          text: "Create Contact",
          color: kWhite,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(width * 0.08, height * 0.04, width * 0.08, 0),
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
                  prefix: Icon(Icons.email),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  hintText: 'Enter Email',
                ),
              ],
            ),
            kHeight(height * 0.01),
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
                  prefix: Icon(Icons.person),
                  controller: c.nameCtr,
                  hintText: 'Enter name',
                  isBoarder: false,
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                ),
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
                            if (c.nameCtr.text.isNotEmpty) {
                              c.addNamesTolist(c.nameCtr.text);
                              c.nameCtr.clear();
                              Get.back();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
