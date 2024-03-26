import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/constants/global.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isChecked = false.obs;
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  var isVisibile = false.obs;
  var isConfirmPasswordVisible = false.obs;
  void changeLoadingState(bool value) {
    isLoading(value);
  }

  void changeCheckBox(bool value) {
    isChecked(value);
  }

  void toggleConfirmPassword() {
    isConfirmPasswordVisible(!isConfirmPasswordVisible.value);
  }

  void toggleEyeIcon() {
    isVisibile(!isVisibile.value);
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateConfirmPassword() {
    if (passwordController.text != confirmPasswordController.text) {
      return "Check Your password";
    }

    return null;
  }

  Future<void> uploadUserDatatoFirebase(File? pickedImage) async {
    String? imageUrl;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await authInstance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final uid = authInstance.currentUser!.uid;
      authInstance.currentUser!.updateDisplayName(
        userNameController.text,
      );

      if (pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("profileimage")
            .child("$uid.jpg");
        await ref.putFile(pickedImage);
        imageUrl = await ref.getDownloadURL();
      }
      final chatUser = ChatUser(
        id: uid,
        name: userNameController.text,
        email: emailController.text,
        location: locationController.text,
        image: imageUrl ?? "https://www.dpforwhatsapp.in/img/no-dp/19.webp",
        about: "Hey,I'm using Chat App",
        isOnline: false,
        pushToken: '',
        lastActive: time,
        createdAt: time,
        isTyping: false,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(chatUser.toJson());
    } on FirebaseException catch (e) {
      Get.snackbar("Something Wrong", e.message.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      Get.snackbar("TITLE", e.message.toString());
    }
  }

  Future<void> signOut() async {
    await ChatService.updateActiveStatus(false);
    await authInstance.signOut();
  }
}
