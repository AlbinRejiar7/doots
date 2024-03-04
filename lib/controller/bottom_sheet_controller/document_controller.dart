import 'dart:developer';

import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class DocumentController extends GetxController {
  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  var c = Get.put(ChattingScreenController());

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      selectedFile(result.files.single);
      log(selectedFile.value!.size.toString());

      String fileName = selectedFile.value!.name;
      String? exe = selectedFile.value!.extension;

      double sizeInBytes = selectedFile.value!.size.toDouble();
      double sizeInKB = sizeInBytes / 1024;
      double sizeInMB = sizeInKB / 1024;

      String size;
      if (sizeInMB >= 1) {
        size = "${sizeInMB.toStringAsFixed(2)} MB";
      } else {
        size = "${sizeInKB.toStringAsFixed(2)} KB";
      }

      c.addchat(
        selectedFile.value!.path ?? "",
        MessageType.document,
        fileName: fileName,
        extension: exe,
        size: size,
      );
    } else {
      Get.snackbar("Canceled", "No file selected");
    }
  }

  Future<void> openFile(String? filePath) async {
    if (filePath != null) {
      await OpenFilex.open(filePath);
    } else {
      Get.snackbar("Invalid", "invalid file path");
    }
  }
}
