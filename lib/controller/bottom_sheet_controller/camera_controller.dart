import 'dart:developer';
import 'dart:io';

import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraController {
  final ImagePicker picker = ImagePicker();
  var c = Get.put(ChattingScreenController());
  var gallaryCtr = Get.put(GallaryController());

  Future<void> takePhoto(String chatUserId, String groupId) async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      log("message${photo.path}");
      gallaryCtr.changeUploadingState(true);
      await ChatService.sendImage(
          chatUserId, groupId, File(photo.path), 'image');
      gallaryCtr.changeUploadingState(false);
    } else {
      Get.snackbar("Photo", "No Photo Taken");
    }
  }
}

// Widget cameraPhotoBubble(
//     var height, var width, BuildContext context, String path) {
//   return InkWell(
//     onTap: () {
//       Get.to(() => CameraPhotoViewer(path: path));
//     },
//     child: Padding(
//       padding: EdgeInsets.only(right: width * 0.02, top: height * 0.01),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             alignment: Alignment.centerRight,
//             height: height * 0.3,
//             margin: EdgeInsets.only(left: width * 0.48),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: kgreen1.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(7),
//                   image: DecorationImage(
//                       fit: BoxFit.cover, image: FileImage(File(path)))),
//             ),
//           ),
//           Text(DateFormat.jm().format(DateTime.now()),
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontSize: 12)),
//         ],
//       ),
//     ),
//   );
// }

// class CameraPhotoViewer extends StatelessWidget {
//   final String path;
//   const CameraPhotoViewer({super.key, required this.path});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PhotoView(imageProvider: FileImage(File(path))),
//     );
//   }
// }
