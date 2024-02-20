import 'dart:developer';

import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraController {
  final ImagePicker picker = ImagePicker();
  var c = Get.put(ChattingScreenController());
  Future<void> takePhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      log("message${photo.path}");
      c.addchat(photo.path, MessageType.capturePhoto);
    } else {
      Get.snackbar("Photo", "No Photo Taken");
    }
  }
}
