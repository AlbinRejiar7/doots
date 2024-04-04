import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController {
  var isDownloading = false.obs;
  var data = GetStorage();

  void changeIsDownloadingState(bool value) {
    isDownloading(value);
  }

  Future<void> saveNetworkImage(String path) async {
    await GallerySaver.saveImage(
      path,
    ).then((success) {
      Get.snackbar("Success", "downloaded");
    });
  }

  Future<void> saveNetworkVideo(String path) async {
    await GallerySaver.saveVideo(
      albumName: "video",
      path,
    ).then((success) {
      Get.snackbar("Success", "downloaded");
    });
  }

  Future<String> getDownloadsDirectoryPath() async {
    final directory = await getDownloadsDirectory();
    return directory!.path;
  }

  Future<void> downloadFileFromFirebase(String url, String fileName) async {
    try {
      final directory = await getDownloadsDirectoryPath();

      final downloadTask = await Dio().download(
        url,
        directory + fileName,
        onReceiveProgress: (received, total) {
          final progress = (received / total) * 100;
          log('Download progress: ${progress / 100}%');
        },
      );
      await data.write(fileName, directory + fileName);
      log(data.read(fileName) + "this is from local storage");

      if (downloadTask.statusCode == 200) {
        log('File downloaded successfully: $directory');
      } else {
        log('Download failed with status code: ${downloadTask.statusCode}');
      }
    } catch (error) {
      log('Error downloading file: $error');
    }
  }

  Future<void> downloadAudioFromFirebase(String url, String fileName) async {
    try {
      final directory = await getDownloadsDirectoryPath();

      final downloadTask = await Dio().download(
        url,
        directory + fileName,
        onReceiveProgress: (received, total) {
          final progress = (received / total) * 100;
          log('Download progress: ${progress / 100}%');
        },
      );
      await data.write(fileName, directory + fileName);
      log(data.read(fileName) + "this is from local storage");

      if (downloadTask.statusCode == 200) {
        log('File downloaded successfully: $directory');
      } else {
        log('Download failed with status code: ${downloadTask.statusCode}');
      }
    } catch (error) {
      log('Error downloading file: $error');
    }
  }

  Future<void> downloadVideoFromFirebase(String url, String fileName) async {
    try {
      String directory = '/storage/emulated/0/Movies/';

      final downloadTask = await Dio().download(
        url,
        directory + fileName,
        onReceiveProgress: (received, total) {
          final progress = (received / total) * 100;
          log('Download progress: ${progress / 100}%');
        },
      );
      await data.write(fileName, directory + fileName);
      log(data.read(fileName) + "this is from local storage");

      if (downloadTask.statusCode == 200) {
        log('File downloaded successfully: $directory');
      } else {
        log('Download failed with status code: ${downloadTask.statusCode}');
      }
    } catch (error) {
      log('Error downloading file: $error');
    }
  }

  // List<File> videoPaths = [];
  // String url =
  //     'https://dcblog.b-cdn.net/wp-content/uploads/2021/02/Full-form-of-URL-1-1024x824.jpg';
  // var c = Get.put(ChattingScreenController());
  // var isLoading = false.obs;
  // var progress;
  // File? downloadFile;

  // List<String> thumbnails = [];
  // void downloader() async {
  //   try {
  //     await FileDownloader.downloadFile(
  //         url: url.trim(),
  //         onProgress: (name, progresses) {
  //           progress = progresses;
  //           update();
  //         },
  //         onDownloadCompleted: (value) {
  //           print('path  $value ');

  //           progress = null;
  //         });
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<void> downloadVideo() async {
  //   isLoading(true);
  //   var id = const Uuid().v4();
  //   log(id.toString());

  //   final response = await http.get(
  //     Uri.parse(
  //         'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
  //     headers: {'Content-Type': 'video/mp4'},
  //   );

  //   if (response.statusCode == 200) {
  //     final directory = await getExternalStorageDirectory();
  //     final file = File('${directory?.path}/$id.mp4');
  //     final finalFile = await file.writeAsBytes(response.bodyBytes);
  //     videoPaths.add(finalFile);
  //     var thumbnail = await VideoThumbnail.thumbnailFile(
  //       video: finalFile.path,
  //       thumbnailPath: (await getTemporaryDirectory()).path,
  //       imageFormat: ImageFormat.PNG,
  //     );
  //     thumbnails.add(thumbnail!);

  //     c.addchat(videoPaths, MessageType.videos, thumbnail: thumbnail);
  //     isLoading(false);
  //   } else {
  //     Get.snackbar("Error", response.statusCode.toString());
  //     isLoading(false);
  //   }
  // }
}
