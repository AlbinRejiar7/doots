import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/auth_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/view/auth/signin_screen.dart';
import 'package:doots/widgets/custom_auth_button.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var c = Get.put(AuthController());
    var width = context.width;
    var height = context.height;
    var gallaryCtr = Get.put(GallaryController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.1),
            child: Form(
              key: formKey1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      ChooseProfilePicture(
                          height: height, gallaryCtr: gallaryCtr, width: width),
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'Email'),
                          kHeight(height * 0.01),
                          CustomTextField(
                            controller: c.emailController,
                            hintText: "Enter Email Id",
                            validator: (p0) {
                              return c.validateEmail(p0!);
                            },
                          )
                        ],
                      ),
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'User name'),
                          kHeight(height * 0.01),
                          CustomTextField(
                            hintText: "Enter user name",
                            controller: c.userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter user name";
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'Password'),
                          kHeight(height * 0.01),
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
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'Confirm Password'),
                          kHeight(height * 0.01),
                          Obx(() {
                            return CustomTextField(
                              controller: c.confirmPasswordController,
                              obscureText: !c.isConfirmPasswordVisible.value,
                              hintText: "Enter Your Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    c.toggleConfirmPassword();
                                  },
                                  icon: c.isConfirmPasswordVisible.value
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off_sharp)),
                              validator: (value) {
                                return c.validateConfirmPassword();
                              },
                            );
                          })
                        ],
                      ),
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'Number'),
                          kHeight(height * 0.01),
                          CustomTextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length != 10) {
                                  return "enter valid number";
                                }
                                return null;
                              },
                              controller: c.phoneController,
                              hintText: "Enter Phone Number")
                        ],
                      ),
                      kHeight(height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(text: 'Location'),
                          kHeight(height * 0.01),
                          CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "enter location";
                                }
                                return null;
                              },
                              controller: c.locationController,
                              hintText: "Enter Location")
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
                      Obx(() {
                        return c.isLoading.value
                            ? CircularProgressIndicator()
                            : CustomAuthButton(
                                title: 'Register',
                                onTap: () async {
                                  if (formKey1.currentState!.validate()) {
                                    c.changeLoadingState(true);
                                    await c
                                        .uploadUserDatatoFirebase(
                                            gallaryCtr.selectedImage.value)
                                        .then((value) {
                                      c.changeLoadingState(false);

                                      gallaryCtr.selectedImage.value = null;
                                      c.emailController.clear();
                                      c.userNameController.clear();
                                      c.passwordController.clear();
                                      c.confirmPasswordController.clear();
                                      c.locationController.clear();
                                      Get.off(() => const SigninScreen());
                                    });
                                  }
                                },
                              );
                      }),
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
                          kWidth(width * 0.02),
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
      ),
    );
  }
}

class ChooseProfilePicture extends StatelessWidget {
  const ChooseProfilePicture({
    super.key,
    required this.gallaryCtr,
    required this.width,
    required this.height,
  });

  final GallaryController gallaryCtr;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return gallaryCtr.selectedImage.value == null
          ? GestureDetector(
              onTap: () {
                gallaryCtr.openGalleryPicker();
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: width * 0.2,
                    backgroundImage: const NetworkImage(
                        "https://www.dpforwhatsapp.in/img/no-dp/19.webp"),
                  ),
                  kHeight(height * 0.01),
                  const Icon(Icons.photo)
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                gallaryCtr.openGalleryPicker();
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: width * 0.2,
                    backgroundImage: FileImage(gallaryCtr.selectedImage.value!),
                  ),
                  kHeight(height * 0.01),
                  const Icon(Icons.add_a_photo_outlined)
                ],
              ),
            );
    });
  }
}
