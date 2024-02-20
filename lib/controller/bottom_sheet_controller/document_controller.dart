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

      String fileName = selectedFile.value!.name;
      String? exe = selectedFile.value!.extension;
      double? size = selectedFile.value!.size / 1000000;
      c.addchat(
        selectedFile.value!.path ?? "",
        MessageType.document,
        fileName: fileName,
        extension: exe,
        size: size.toStringAsFixed(1),
      );
      Get.back();
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
