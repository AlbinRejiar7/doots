import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DownloadController extends GetxController {
  List<File> videoPaths = [];
  String url =
      'https://dcblog.b-cdn.net/wp-content/uploads/2021/02/Full-form-of-URL-1-1024x824.jpg';
  var c = Get.put(ChattingScreenController());
  var isLoading = false.obs;
  var progress;
  File? downloadFile;

  List<String> thumbnails = [];
  void downloader() async {
    try {
      await FileDownloader.downloadFile(
          url: url.trim(),
          onProgress: (name, progresses) {
            progress = progresses;
            update();
          },
          onDownloadCompleted: (value) {
            print('path  $value ');

            progress = null;
          });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> downloadVideo() async {
    isLoading(true);
    var id = const Uuid().v4();
    log(id.toString());

    final response = await http.get(
      Uri.parse(
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
      headers: {'Content-Type': 'video/mp4'},
    );

    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory?.path}/$id.mp4');
      final finalFile = await file.writeAsBytes(response.bodyBytes);
      videoPaths.add(finalFile);
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: finalFile.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
      );
      thumbnails.add(thumbnail!);

      c.addchat(videoPaths, MessageType.videos, thumbnail: thumbnail);
      isLoading(false);
    } else {
      Get.snackbar("Error", response.statusCode.toString());
      isLoading(false);
    }
  }
}
