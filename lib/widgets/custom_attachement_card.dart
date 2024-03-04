import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/audio_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/camera_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/bottom_sheet_controller/location_controller.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAttachement extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int index;
  final bool? isDetailScreen;

  const CustomAttachement({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.index,
    this.isDetailScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var documentCtr = Get.put(DocumentController());
    var galleryCtr = Get.put(GallaryController());
    var locationCtr = Get.put(LocationController());
    var audioCtr = AudioFileController();

    return Column(
      children: [
        CircleAvatar(
            backgroundColor: color,
            child: IconButton(
              onPressed: () async {
                if (index == 0 && isDetailScreen == false) {
                  await documentCtr.pickDocument();
                }
                if (index == 1 && isDetailScreen == false) {
                  await CameraController().takePhoto();
                }
                if (index == 2 && isDetailScreen == false) {
                  await galleryCtr.openImagePicker();
                }
                if (index == 3 && isDetailScreen == false) {
                  await audioCtr.pickAudio();
                }
                if (index == 4 && isDetailScreen == false) {
                  await locationCtr.getCurrentLocation();
                }
                if (index == 6 && isDetailScreen == false) {
                  // await galleryCtr.pickVideo();
                }
              },
              icon: Icon(
                icon,
                color: kgreen1,
                size: 17,
              ),
            )),
        kHeight(height * 0.01),
        FittedBox(
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 11),
          ),
        )
      ],
    );
  }
}
