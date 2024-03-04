import 'package:doots/constants/color_constants.dart';
import 'package:doots/view/auth/signin_screen.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icons/bxs-message-alt-detail.png",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    kWidth(10),
                    Flexible(
                      child: CustomTextWidget(
                        text: "Doots",
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomTextWidget(
                      text: "Register Account",
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    kHeight(height * 0.01),
                    CustomTextWidget(
                      text: "Get your free Doot account now ",
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(text: 'Email'),
                        kHeight(height * 0.01),
                        CustomTextField(hintText: "Enter Email Id")
                      ],
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(text: 'User name'),
                        kHeight(height * 0.01),
                        CustomTextField(hintText: "Enter user name")
                      ],
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(text: 'Password'),
                        kHeight(height * 0.01),
                        CustomTextField(hintText: "Enter Your Password")
                      ],
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(text: 'Confirm Password'),
                        kHeight(height * 0.01),
                        CustomTextField(hintText: "Re enter Password")
                      ],
                    ),
                    kHeight(height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(text: 'Location'),
                        kHeight(height * 0.01),
                        CustomTextField(hintText: "Enter Location")
                      ],
                    ),
                    kHeight(height * 0.01),
                    const CustomTextWidget(
                        text: 'By registering you agree to the Doot'),
                    const CustomTextWidget(
                      text: 'Terms of Use',
                      color: kGreen,
                    ),
                    kHeight(height * 0.03),
                    const CustomAuthButton(title: 'Register'),
                    kHeight(height * 0.035),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Divider(
                          color: kblack.withOpacity(0.1),
                        )),
                        const CustomTextWidget(text: 'Sign up using'),
                        Expanded(
                            child: Divider(
                          color: kblack.withOpacity(0.1),
                        )),
                      ],
                    ),
                    kHeight(height * 0.03),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8),
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
                            margin: const EdgeInsets.all(8),
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
                        )
                      ],
                    ),
                    kHeight(height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWidget(
                            text: "already have and account ?"),
                        kWidth(10),
                        InkWell(
                          onTap: () {
                            Get.off(() => SigninScreen());
                          },
                          child: const CustomTextWidget(
                            text: "Login",
                            color: kGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
