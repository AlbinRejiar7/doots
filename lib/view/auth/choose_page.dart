import 'package:doots/constants/color_constants.dart';
import 'package:doots/view/auth/signin_screen.dart';
import 'package:doots/view/auth/signup_screen.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoosingPage extends StatelessWidget {
  const ChoosingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icons/bxs-message-alt-detail.png",
                color: kblack,
              ),
              kWidth(10),
              Flexible(
                child: CustomTextWidget(
                  text: "Doots",
                  color: kblack,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(
                      "assets/images/background/authChoosePage.jpeg"))),
          child: Padding(
            padding: EdgeInsets.all(width * 0.1),
            child: SafeArea(
              child: Column(
                children: [
                  CustomTextWidget(
                    color: kblack,
                    text: "Welcome To Doots !",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  Image.asset(
                      height: height * 0.3,
                      "assets/images/icons/Google_Chat_Logo_512px.png"),
                  const Spacer(),
                  CustomAuthButton(
                    color: Colors.green,
                    title: "Sign up",
                    onTap: () {
                      Get.to(() => const SignUpScreen());
                    },
                  ),
                  kHeight(height * 0.03),
                  CustomAuthButton(
                    color: Colors.green,
                    title: "Sign in",
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => SigninScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
