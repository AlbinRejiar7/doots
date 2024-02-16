import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioController extends GetxController {
  AudioRecorder audioRecorder = AudioRecorder();
  var isRecording = false.obs;
  var universalRecordingPath = ''.obs;
  var isPlaying = false.obs;
  var player = AudioPlayer();
  var progressIndex = RxInt(0);
  var isMicrophoneGranted = false.obs;

  void micPermission(bool value) {
    isMicrophoneGranted(value);
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        await audioRecorder.start(const RecordConfig(),
            path: '${directory.path}/${Uuid().v4()}myFile.m4a');

        isRecording(true);
      }
    } catch (e) {
      print('${e}errorrrrrrrrrr');
    }
  }

  Future<void> playAudio(String filePath, int currentPlayingIndex) async {
    try {
      await player.setFilePath(
        filePath,
      );

      await player.play();

      progressIndex.value = currentPlayingIndex;
    } catch (e) {
      print("Error playing audio: ${e.toString()}");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecorder.stop();
      print("${path}this is the pathhhhhhhhhhhhhhhhhhhhhh");
      universalRecordingPath(path);
      isRecording(false);
    } catch (e) {
      print('${e}errorrrrrrrrrr');
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();

    audioRecorder.dispose();
  }
}
