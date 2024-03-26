import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GallaryController extends GetxController {
  List<XFile>? pickedImage;
  var isUploading = false.obs;

  List<PlatformFile>? pickedVideos;
  var c = Get.put(ChattingScreenController());

  void changeUploadingState(bool value) {
    isUploading(value);
  }

  // Future<void> openImagePicker() async {
  //   final ImagePicker picker = ImagePicker();
  //   List<String> photoExtensions = ['jpg', 'jpeg', 'png'];
  //   List<String> videoExtensions = ['mp4', 'mov'];

  //   final List<XFile> medias = await picker.pickMultipleMedia();
  //   List<String> photosAndVideos = [];
  //   List<String> thumbnails = [];
  //   photosAndVideos = medias.map<String>((xfile) => xfile.path).toList();

  //   for (String filePath in photosAndVideos) {
  //     String extension = filePath.split('.').last.toLowerCase();

  //     if (photoExtensions.contains(extension)) {
  //       photoPaths.add(File(filePath));
  //       // c.addchat(photoPaths, MessageType.photos);
  //     } else if (videoExtensions.contains(extension)) {
  //       videoPaths.add(File(filePath));
  //       var thumbnail = await VideoThumbnail.thumbnailFile(
  //         video: filePath,
  //         thumbnailPath: (await getTemporaryDirectory()).path,
  //         imageFormat: ImageFormat.PNG,
  //       );
  //       thumbnails.add(thumbnail!);

  //       // c.addchat(videoPaths, MessageType.videos, thumbnail: thumbnail);
  //     }
  //   }
  // }

  final Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> openGalleryPicker() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage.value = File(pickedImage.path);
    } else {
      if (kDebugMode) {
        print('Image not Selected');
      }
    }
  }

  Future<void> pickImageAndUploadToFirestore(
      {required String chatUserId, required String groupId}) async {
    pickedImage = await ImagePicker().pickMultiImage(imageQuality: 70);
    if (pickedImage != null) {
      for (var xfile in pickedImage!) {
        changeUploadingState(true);
        await ChatService.sendImage(
            chatUserId, groupId, File(xfile.path), 'image');
        changeUploadingState(false);
      }
    } else {
      if (kDebugMode) {
        print('Image not Selected');
      }
    }
  }

  Future<void> pickVideoAndUploadToFirestore(
      {required String chatUserId, required String groupId}) async {
    FilePickerResult? selectedVideos = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (selectedVideos != null) {
      pickedVideos = selectedVideos.files;
      pickedVideos!.forEach((platformfile) async {
        changeUploadingState(true);
        try {
          var thumbnailLocalPath = await VideoThumbnail.thumbnailFile(
            video: platformfile.path!,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.PNG,
          );
          final ext = platformfile.extension;
          final ref = ChatService.storage.ref().child(
              'thumbnails/${ChatService.getConversationID(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

          await ref.putFile(File(thumbnailLocalPath!)).then((p0) {
            log("Data Transfer: ${p0.bytesTransferred / 1000} kb");
          });

          final thumbnailUrl = await ref.getDownloadURL();
          await ChatService.sendVideo(
              chatUserId: chatUserId,
              groupId: groupId,
              videoName: platformfile.name,
              video: File(platformfile.path!),
              type: 'video',
              localPath: platformfile.path!,
              thumbnailPath: thumbnailUrl,
              thumbnailLocalPath: thumbnailLocalPath);
          changeUploadingState(false);
        } on FirebaseException catch (e) {
          Get.snackbar("title", e.message.toString());
        }
      });
    } else {
      Get.snackbar("title", "no video selected");
    }
  }
}
