import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/auth_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/view/auth/signup_screen.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    super.key,
  });

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var c = Get.put(AuthController());
  var profileCtr = Get.put(ProfilePageController());
  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: width * 0.1, right: width * 0.1, top: height * 0.26),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      controller: c.emailController,
                      hintText: "Enter Email Id",
                      validator: (p0) {
                        return c.validateEmail(p0!);
                      },
                    )
                  ],
                ),
                kHeight(height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: 'Password',
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        const CustomTextWidget(text: 'Forgot password?'),
                      ],
                    ),
                    kHeight(6),
                    Obx(() {
                      return CustomTextField(
                        controller: c.passwordController,
                        obscureText: !c.isVisibile.value,
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                            onPressed: () {
                              c.toggleEyeIcon();
                            },
                            icon: c.isVisibile.value
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off_sharp)),
                        validator: (p0) {
                          return c.validatePassword(p0!);
                        },
                      );
                    })
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
                    const CustomTextWidget(text: "Remember me")
                  ],
                ),
                Obx(() {
                  return c.isLoading.value
                      ? const CircularProgressIndicator()
                      : CustomAuthButton(
                          title: 'Log in',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              c.changeLoadingState(true);
                              await c
                                  .signIn(c.emailController.text,
                                      c.passwordController.text)
                                  .then((value) async {
                                c.changeLoadingState(false);

                                c.emailController.clear();
                                c.passwordController.clear();
                              });
                            }
                          },
                        );
                }),
                kHeight(height * 0.02),
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
                kHeight(height * 0.02),
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
                    ),
                  ],
                ),
                kHeight(height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextWidget(text: "Dont have an account ?"),
                    kWidth(10),
                    InkWell(
                      onTap: () {
                        Get.off(() => const SignUpScreen());
                      },
                      child: const CustomTextWidget(
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
        ),
      ),
    );
  }
}
