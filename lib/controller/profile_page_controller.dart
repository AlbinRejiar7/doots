import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/constants/global.dart';
import 'package:doots/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  ChatUser? currentUserData;
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController locationCtr = TextEditingController();
  TextEditingController numberCtr = TextEditingController();
  TextEditingController statusCtr = TextEditingController();
  Future<void> fetchUserData() async {
    User? user = authInstance.currentUser;
    try {
      String userId = user!.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      currentUserData =
          ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      Get.snackbar("title", e.message.toString());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await fetchUserData();
  }
}
