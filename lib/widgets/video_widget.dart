import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGallery extends StatelessWidget {
  final int initialIndex;
  final List<File> videoFiles;

  const VideoGallery({
    Key? key,
    required this.initialIndex,
    required this.videoFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: videoFiles.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return VideoPlayerScreen(videoFile: videoFiles[index]);
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  const VideoPlayerScreen({Key? key, required this.videoFile})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late double aspectRatio;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    await _videoPlayerController.initialize();
    setState(() {
      aspectRatio = _videoPlayerController.value.aspectRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChewieListItem(
              ratio: aspectRatio,
              videoPlayerController: _videoPlayerController,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final double ratio;

  const ChewieListItem(
      {Key? key, required this.videoPlayerController, required this.ratio})
      : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      aspectRatio: widget.ratio,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      zoomAndPan: true,
      allowFullScreen: false,
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      looping: false,
      autoPlay: false,
      showControls: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
