import 'dart:io';

import 'package:doots/service/chat_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class AudioFileController extends GetxController {
  Rx<Duration?> durationOfAudio = Rx<Duration?>(null);
  PlatformFile? selectedFile;

  void changeDuration(Duration duration) {
    durationOfAudio(duration);
  }

  Future<void> pickAudioAndUploadToFirebase(
      {required String chatUserId, required String groupId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      selectedFile = result.files.single;
      String fileName = selectedFile!.name;
      double? size = selectedFile!.size / 1000000;
      ChatService.sendAudioDoc(
        duration: '',
        chatUserId: chatUserId,
        groupId: groupId,
        file: File(selectedFile!.path!),
        type: 'audio',
        fileName: fileName,
        fileSize: size.toString(),
        localPath: selectedFile!.path!,
      );
    } else {
      Get.snackbar("Canceled", "No file selected");
    }
  }

  Future<void> openFile(String? filePath) async {
    if (filePath != null) {
      await OpenFilex.open(filePath);
    } else {
      Get.snackbar("Invalid", "invalid file");
    }
  }
}
