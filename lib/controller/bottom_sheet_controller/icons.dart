import 'package:flutter/material.dart';

enum MessageType {
  text,
  audio,
  document,
  photos,
  videos,
  capturePhoto,
  location,
  audioDocument,
}

List<String> title = [
  'DOCUMENTS',
  "CAMERA",
  "PHOTO",
  "AUDIO",
  "LOCATION",
  "CONTACTS",
  "VIDEOS"
];
List<IconData> myIcons = [
  Icons.edit_document,
  Icons.camera_alt,
  Icons.photo_library,
  Icons.headset,
  Icons.location_on,
  Icons.contacts,
  Icons.video_library
];
