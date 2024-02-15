// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kgreen1,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(
                left: width * 0.06,
                right: width * 0.06,
                top: height * 0.06,
              ),
              margin: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  top: height * 0.15,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).scaffoldBackgroundColor),
              height: context.height * 0.7,
              width: context.width,
              child: Column(
                children: [
                  CustomTextWidget(
                    color: Theme.of(context).colorScheme.primary,
                    text: "Change password",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  kHeight(height * 0.05),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                      ),
                      Text(
                        "username",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  kHeight(height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: 'New password',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      kHeight(6),
                      CustomTextField(
                        hintText: "Enter New Password",
                      )
                    ],
                  ),
                  kHeight(height * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'Confirm New Password',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      kHeight(6),
                      CustomTextField(
                        obscureText: true,
                        hintText: "Enter Confirm Password",
                        suffixIcon: Icon(Icons.visibility_off),
                      )
                    ],
                  ),
                  kHeight(height * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: CustomAuthButton(
                          title: 'Save',
                          onTap: () {},
                        ),
                      ),
                      kWidth(width * 0.04),
                      Expanded(
                        child: CustomAuthButton(
                          textColor: Theme.of(context).colorScheme.primary,
                          color: Theme.of(context).primaryColor,
                          title: 'cancel',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
