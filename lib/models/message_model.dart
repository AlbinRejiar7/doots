import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/service/chat_services.dart';

class Message {
  String toId;
  String msg;
  String read;
  String messageType;
  String fromId;
  String sent;
  String ext;
  String size;
  String filename;
  String localFileLocation;
  bool isDownloaded;
  bool isDownloading;
  String thumbnailPath;
  String localThumbnailPath;
  String duration;
  String replyMessage;
  String? name;
  bool? isDeleted; // New field

  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.messageType,
    required this.fromId,
    required this.sent,
    required this.ext,
    required this.size,
    required this.filename,
    required this.localFileLocation,
    required this.thumbnailPath,
    required this.localThumbnailPath,
    required this.duration,
    this.isDownloaded = false,
    this.isDownloading = false,
    required this.replyMessage,
    this.name,
    this.isDeleted = false, // Initialize the new field
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        toId: json["toId"],
        msg: json["msg"],
        read: json["read"],
        messageType: json["messageType"],
        fromId: json["fromId"],
        sent: json["sent"],
        ext: json["ext"],
        size: json["size"],
        filename: json["filename"],
        localFileLocation: json["localFileLocation"],
        thumbnailPath: json["thumbnailPath"],
        localThumbnailPath: json["localThumbnailPath"],
        duration: json["duration"],
        isDownloaded: json["isDownloaded"],
        isDownloading: json["isDownloading"],
        replyMessage: json["replyMessage"],
        name: json["name"],
        isDeleted: json["isDeleted${ChatService.user.uid}"] ??
            false, // New field with default value
      );

  Map<String, dynamic> toJson() => {
        "toId": toId,
        "msg": msg,
        "read": read,
        "messageType": messageType,
        "fromId": fromId,
        "sent": sent,
        "ext": ext,
        "size": size,
        "filename": filename,
        "localFileLocation": localFileLocation,
        "thumbnailPath": thumbnailPath,
        "localThumbnailPath": localThumbnailPath,
        "duration": duration,
        "isDownloaded": isDownloaded,
        "isDownloading": isDownloading,
        "replyMessage": replyMessage,
        if (name != null) "name": name,
        "isDeleted${ChatService.user.uid}": isDeleted, // New field
        "createdAt": FieldValue.serverTimestamp(),
      };
}
