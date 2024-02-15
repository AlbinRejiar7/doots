// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/auth_controller.dart';
import 'package:doots/view/home/home_page.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(AuthController());
    var width = context.width;
    var height = context.height;
    return Obx(() {
      return c.isLoginScreen.value
          ? Container(
              padding: EdgeInsets.only(
                left: width * 0.06,
                right: width * 0.06,
                top: height * 0.06,
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).scaffoldBackgroundColor),
              height: context.height * 0.7,
              width: context.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextWidget(
                      color: Theme.of(context).colorScheme.primary,
                      text: "Welcome back !",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      color: Theme.of(context).colorScheme.primary,
                      text: "Sign in to continue to Doot.",
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'Email',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        kHeight(6),
                        CustomTextField(
                          hintText: "Enter Email Id",
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
                              text: 'Password',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            CustomTextWidget(text: 'Forgot password?'),
                          ],
                        ),
                        kHeight(6),
                        CustomTextField(
                          obscureText: true,
                          hintText: "Enter Your Password",
                          suffixIcon: Icon(Icons.visibility_off),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() {
                          return Checkbox(
                              activeColor: kGreen,
                              value: c.isChecked.value,
                              onChanged: (value) {
                                c.changeCheckBox(value!);
                              });
                        }),
                        CustomTextWidget(text: "Remember me")
                      ],
                    ),
                    CustomAuthButton(
                      title: 'Log in',
                      onTap: () {
                        Get.to(() => HomeScreen());
                      },
                    ),
                    kHeight(height * 0.02),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Divider(
                          color: kblack.withOpacity(0.1),
                        )),
                        CustomTextWidget(text: 'Sign up using'),
                        Expanded(
                            child: Divider(
                          color: kblack.withOpacity(0.1),
                        )),
                      ],
                    ),
                    kHeight(height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: height * 0.05,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: SizedBox(
                                    height: height * 0.025,
                                    child: Image.asset(
                                        fit: BoxFit.cover,
                                        'assets/images/icons/fbicon.png'))),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: height * 0.05,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: SizedBox(
                                    height: height * 0.025,
                                    child: Image.asset(
                                        fit: BoxFit.cover,
                                        'assets/images/icons/google.png'))),
                          ),
                        ),
                      ],
                    ),
                    kHeight(height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextWidget(text: "Dont have an account ?"),
                        kWidth(10),
                        InkWell(
                          onTap: () {
                            c.changeAuthScreen();
                          },
                          child: CustomTextWidget(
                            text: "Register",
                            color: kGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : SignInScreen();
    });
  }
}
