import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/view/chating_screen/chating_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentController extends GetxController {
  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  var c = Get.put(ChattingScreenController());

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      selectedFile(result.files.single);
      c.addchat(
        selectedFile.value!.path ?? "",
        MessageType.document,
      );
      Get.back();
    } else {
      Get.snackbar("Canceled", "No file selected");
    }
  }

  Future<void> openFile(String? filePath) async {
    if (filePath != null) {
      await OpenFilex.open(filePath);
    }
  }

  Future<void> openDocument(String? filePath) async {
    if (filePath != null) {
      final Uri uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Handle errors
        print('Could not launch $filePath');
      }
    } else {
      print('File path is null');
    }
  }
}
