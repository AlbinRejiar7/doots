import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class AudioFileController {
  var c = Get.put(ChattingScreenController());

  Future<void> pickAudio() async {
    PlatformFile? selectedFile;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      selectedFile = result.files.single;
      String fileName = selectedFile.name;
      String? exe = selectedFile.extension;
      double? size = selectedFile.size / 1000000;
      c.addchat(
        selectedFile.path ?? "",
        MessageType.audioDocument,
        fileName: fileName,
        extension: exe,
        size: size.toStringAsFixed(1),
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
