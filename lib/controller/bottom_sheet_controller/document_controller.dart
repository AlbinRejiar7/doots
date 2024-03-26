import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class DocumentController extends GetxController {
  var isDocumentUploading = false.obs;

  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  String? size;
  void changeUploadingState(bool value) {
    isDocumentUploading(value);
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      selectedFile(result.files.single);

      double sizeInBytes = selectedFile.value!.size.toDouble();
      double sizeInKB = sizeInBytes / 1024;
      double sizeInMB = sizeInKB / 1024;

      if (sizeInMB >= 1) {
        size = "${sizeInMB.toStringAsFixed(2)} MB";
      } else {
        size = "${sizeInKB.toStringAsFixed(2)} KB";
      }
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
