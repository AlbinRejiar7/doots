import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GroupDetailsScreenController extends GetxController {
  List<ChatUser> groupMembersInfo = [];
  void removeMemberFromGroup(
    String groupId,
    String memberToRemove,
    String adminId,
  ) async {
    if (memberToRemove == adminId) {
      // Do not remove the admin
      Fluttertoast.showToast(msg: 'Cannot remove admin from the group');
      return;
    }

    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    // Update the group to remove the member
    await groupRef.update({
      'membersId': FieldValue.arrayRemove([memberToRemove]),
    }).then((_) {
      print('Member removed successfully');
      Fluttertoast.showToast(msg: 'Member removed successfully');
    }).catchError((error) {
      print('Failed to remove member: $error');
      Fluttertoast.showToast(msg: 'Failed to remove member: $error');
    });
    await ChatService.firestore.collection("users").doc(memberToRemove).update({
      "groupIds": FieldValue.arrayRemove([groupId])
    }).then((_) {
      print("Value added to array successfully");
    }).catchError((error) {
      print("Failed to add value to array: $error");
    });
    groupMembersInfo.removeWhere((element) => element.id == memberToRemove);
    log(groupMembersInfo.map((e) => e.name).toString());
    update();
  }
}
