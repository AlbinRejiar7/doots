import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewer extends StatelessWidget {
  final String image;
  final bool isUser;
  const PhotoViewer({
    super.key,
    required this.image,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    var downloadctr = Get.put(DownloadController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(
          color: kWhite,
        ),
        actions: [
          !isUser
              ? Obx(() {
                  return downloadctr.isDownloading.value
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kWhite,
                        )
                      : ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: kblack),
                          onPressed: () async {
                            downloadctr.changeIsDownloadingState(true);
                            await downloadctr.saveNetworkImage(image);
                            downloadctr.changeIsDownloadingState(false);
                          },
                          icon: const Icon(
                            Icons.download,
                            color: kWhite,
                          ),
                          label: const Text(
                            "Download",
                            style: TextStyle(color: kWhite),
                          ));
                })
              : const SizedBox.shrink()
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: PhotoViewGallery(pageOptions: [
        PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(image))
      ])),
    );
  }
}
// PhotoViewGallery.builder(
//           scrollPhysics: const BouncingScrollPhysics(),
//           builder: (BuildContext context, int index) {
//             return PhotoViewGalleryPageOptions(
//               minScale: PhotoViewComputedScale.contained,
//               imageProvider: CachedNetworkImageProvider(files[index]),
//               heroAttributes: PhotoViewHeroAttributes(tag: tag),
//               initialScale: PhotoViewComputedScale.contained * 0.8,
//             );
//           },
//           itemCount: files.length,
//           loadingBuilder: (context, event) => Center(
//             child: SizedBox(
//               width: 20.0,
//               height: 20.0,
//               child: CircularProgressIndicator(value: event == null ? 0 : 10),
//             ),
//           ),
//           backgroundDecoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           pageController: PageController(initialPage: initialIndex),
//         ),