import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioController extends GetxController {
  late final RecorderController recorderController;
  @override
  void onInit() {
    super.onInit();
    _initialiseControllers();
  }

  late Directory appDirectory;

  var isRecording = false.obs;
  var isLoading = false.obs;
  var universalRecordingPath = ''.obs;
  var isPlaying = false.obs;
  var progressIndex = RxInt(0);
  var isRecordingCompleted = false.obs;
  var isMicrophoneGranted = false.obs;
  var iconSize = 0.06.obs;
  void changeIconSize(var value) {
    iconSize(value);
  }

  void micPermission(bool value) {
    isMicrophoneGranted(value);
  }

  String getFileNameFromPath(String filePath) {
    List<String> pathParts = filePath.split('/');
    return pathParts.last;
  }

  Future<void> cancelRecording() async {
    if (isRecording.value == true) {
      try {
        // Reset recorder controller
        recorderController.reset();
        // Stop recording without saving the file
        await recorderController.stop(true);
        // Update recording status
        isRecording.value = false;
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void startOrStopRecording(
      {required String? chatUserId, required String? groupId}) async {
    if (chatUserId != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        String? path = '${directory.path}/${const Uuid().v4()}myFile.m4a';
        if (isRecording.value == true) {
          recorderController.reset();

          path = await recorderController.stop(false);

          if (path != null) {
            isRecording.value = !isRecording.value;
            update();
            Duration duration = recorderController.recordedDuration;

            isRecordingCompleted.value = true;
            await ChatService.sendAudioDoc(
              chatUserId: chatUserId,
              groupId: groupId!,
              duration: ChatService.formatDuration(duration),
              file: File(path),
              type: 'audio',
              fileName: getFileNameFromPath(path),
              fileSize: '',
              localPath: path,
            );
          }
        } else {
          await recorderController.record(path: path);
          isRecording.value = !isRecording.value;
          update();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }

  void refreshWave() {
    if (isRecording.value) recorderController.refresh();
    update();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatLinearPCM
      ..sampleRate = 44100
      ..bitRate = 320000;
  }

  @override
  void dispose() {
    super.dispose();
    recorderController.dispose();
  }
}
