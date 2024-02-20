// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'dart:io';

import 'package:doots/controller/bottom_sheet_controller/icons.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GallaryController extends GetxController {
  List<File> photoPaths = [];
  List<File> videoPaths = [];
  late List<VideoPlayerController>? videoPlayerController;
  var c = Get.put(ChattingScreenController());

  Future<void> openImagePicker() async {
    List<String> photoExtensions = ['jpg', 'jpeg', 'png'];
    List<String> videoExtensions = ['mp4', 'mov'];
    var picker = ImagePicker();
    final List<XFile>? medias = await picker.pickMultipleMedia();
    if (medias != null) {
      List<String> photosAndVideos = [];
      List<String> thumbnails = [];
      photosAndVideos = medias.map<String>((xfile) => xfile.path).toList();

      for (String filePath in photosAndVideos) {
        String extension = filePath.split('.').last.toLowerCase();

        if (photoExtensions.contains(extension)) {
          photoPaths.add(File(filePath));
          c.addchat(photoPaths, MessageType.photos);
        } else if (videoExtensions.contains(extension)) {
          videoPaths.add(File(filePath));
          var thumbnail = await VideoThumbnail.thumbnailFile(
            video: filePath,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.PNG,
          );
          thumbnails.add(thumbnail!);
          print("this is my thumbnails ${thumbnails}");

          c.addchat(videoPaths, MessageType.videos, thumbnail: thumbnail);
        }
      }
    } else {
      Get.snackbar("Media", "Nothing selected");
    }
  }
}
