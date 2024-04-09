import 'package:doots/view/chating_screen/widget/media_widgets/media_grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowAllMediaScreen extends StatelessWidget {
  const ShowAllMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Medias"),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: MediaGridViewWidget(isFullScreen: true),
      ),
    );
  }
}
