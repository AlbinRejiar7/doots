import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioController extends GetxController {
  AudioRecorder audioRecorder = AudioRecorder();
  var isRecording = false.obs;
  var universalRecordingPath = ''.obs;
  var isPlaying = false.obs;
  var progressIndex = RxInt(0);
  var isMicrophoneGranted = false.obs;
  var iconSize = 0.06.obs;
  void changeIconSize(var value) {
    iconSize(value);
  }

  void micPermission(bool value) {
    isMicrophoneGranted(value);
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        await audioRecorder.start(const RecordConfig(),
            path: '${directory.path}/${const Uuid().v4()}myFile.m4a');

        isRecording(true);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecorder.stop();

      universalRecordingPath(path);
      isRecording(false);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();

    audioRecorder.dispose();
  }
}
