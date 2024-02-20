import 'package:flutter/material.dart';

enum MessageType {
  text,
  audio,
  document,
  photos,
  videos,
  capturePhoto,
  location,
}

List<String> title = [
  'ATTACHMENT',
  "CAMERA",
  "GALLERY",
  "AUDIO",
  "LOCATION",
  "CONTACTS",
  "AUDIO",
];
List<IconData> myIcons = [
  Icons.edit_document,
  Icons.camera_alt,
  Icons.photo_library,
  Icons.headset,
  Icons.location_on,
  Icons.contacts,
  Icons.mic_none
];
