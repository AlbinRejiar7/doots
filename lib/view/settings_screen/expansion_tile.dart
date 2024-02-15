// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/constants/color_constants.dart';
import 'package:doots/view/settings_screen/color_picker.dart';
import 'package:doots/view/settings_screen/dropdown.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return ListView(
      children: [
        MyExpansionTile(
          title: 'Personal Info',
          icon: Icons.person,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          CustomTextWidget(
                            text: "Albin",
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                      CustomCardButton(
                        icon: Icons.edit,
                      )
                    ],
                  ),
                  kHeight(height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      CustomTextWidget(
                        text: "adl@gmail.com",
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                  kHeight(height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      CustomTextWidget(
                        text: "Azhakam",
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                  kHeight(height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "Enter number",
                              isBoarder: false,
                              fillColor: Theme.of(context).primaryColor,
                              filled: true,
                            ),
                          ),
                          CustomCardButton(icon: Icons.add)
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          CustomCardButton(
                            icon: Icons.edit,
                            onTap: () {},
                          )
                        ],
                      ),
                      CustomTextWidget(
                        text: "undefined",
                        fontWeight: FontWeight.w600,
                      ),
                      kHeight(height * 0.02)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        MyExpansionTile(
          title: 'Themes',
          icon: Icons.color_lens,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CHOOSE THEME COLOR :',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 13),
                  ),
                  kHeight(height * 0.02),
                  ColorPicker(),
                  kHeight(height * 0.02),
                ],
              ),
            )
          ],
        ),
        MyExpansionTile(
          title: 'Privacy',
          icon: Icons.privacy_tip,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile Photo",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      MyDropdownButton(),
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last Seen",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          activeColor: kgreen1, value: true, onChanged: (a) {})
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      MyDropdownButton()
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Read receipts",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          activeColor: kgreen1, value: true, onChanged: (a) {})
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Read receipts",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      MyDropdownButton()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        MyExpansionTile(
          title: 'Security',
          icon: Icons.security,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Show security notification",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          activeColor: kgreen1, value: true, onChanged: (a) {})
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "notification sound",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          activeColor: kgreen1, value: true, onChanged: (a) {})
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        MyExpansionTile(
          title: 'Help',
          icon: Icons.help,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "FAQs",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    children: [
                      Text(
                        "Contacts",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  kHeight(height * 0.02),
                  Row(
                    children: [
                      Text(
                        "Terms & privacy policy",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class CustomCardButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  const CustomCardButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return SizedBox(
      height: height * 0.07,
      width: height * 0.07,
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Icon(
            icon,
            color: kgreen1,
          ),
        ),
      ),
    );
  }
}

class MyExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const MyExpansionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: children,
    );
  }
}
