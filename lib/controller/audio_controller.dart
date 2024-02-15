import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:flutter/widgets.dart';
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

  void togglePlayPause(var path, var index) {
    if (isPlaying.value) {
      player.pause();
    } else {
      if (player.playing) {
        player.seek(Duration.zero); // Restart if already completed
      }
      playAudio(path, index);
    }

    isPlaying(!isPlaying.value);
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        await audioRecorder.start(const RecordConfig(),
            path: '${directory.path}/myFile${const Uuid().v4()}.m4a');

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
      // Handle any errors
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

  Widget progressbar(
    int index,
    Duration? duration,
  ) {
    return StreamBuilder<Duration?>(
        stream: player.positionStream,
        builder: (ctx, snapshot) {
          return Obx(() {
            return ProgressBar(
                progressBarColor: kgreen1,
                thumbColor: kGreen,
                onSeek: (duration) {
                  player.seek(duration);
                },
                buffered: player.bufferedPosition,
                progress: progressIndex.value == index
                    ? snapshot.data ?? Duration.zero
                    : Duration.zero,
                total: duration ?? Duration.zero);
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();

    audioRecorder.dispose();
  }
}
