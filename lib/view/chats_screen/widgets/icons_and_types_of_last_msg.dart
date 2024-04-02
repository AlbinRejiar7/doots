import 'package:flutter/material.dart';

List<String> types = [
  'document',
  'image',
  'audio',
  'video',
];
IconData getMessageIcon(String type) {
  switch (type) {
    case 'document':
      return Icons.file_copy;
    case 'image':
      return Icons.image;
    case 'audio':
      return Icons.audiotrack;
    case 'video':
      return Icons.videocam;
    default:
      return Icons.circle; // Empty space for other types
  }
}
