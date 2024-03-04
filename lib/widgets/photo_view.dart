import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewer extends StatelessWidget {
  final List<File> files;
  final Object tag;
  final int initialIndex;
  const PhotoViewer({
    super.key,
    required this.files,
    required this.tag,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              minScale: PhotoViewComputedScale.contained,
              imageProvider: FileImage(files[index]),
              heroAttributes: PhotoViewHeroAttributes(tag: tag),
              initialScale: PhotoViewComputedScale.contained * 0.8,
            );
          },
          itemCount: files.length,
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(value: event == null ? 0 : 10),
            ),
          ),
          backgroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}
