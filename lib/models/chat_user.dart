// To parse this JSON data, do
//
//     final chatUser = chatUserFromJson(jsonString);

import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
  String? id;
  String? name;
  String? email;
  String? location;
  String? image;
  String? about;
  bool? isOnline;
  bool? isTyping; // Add isTyping boolean value
  String? pushToken;
  String? lastActive;
  String? createdAt;

  ChatUser({
    this.id,
    this.name,
    this.email,
    this.location,
    this.image,
    this.about,
    this.isOnline,
    this.isTyping, // Include isTyping in the constructor
    this.pushToken,
    this.lastActive,
    this.createdAt,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        location: json["location"],
        image: json["image"],
        about: json["about"],
        isOnline: json["is_online"],
        isTyping: json["is_typing"], // Parse isTyping from the JSON
        pushToken: json["push_token"],
        lastActive: json["last_active"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "location": location,
        "image": image,
        "about": about,
        "is_online": isOnline,
        "is_typing": isTyping, // Include isTyping in the JSON
        "push_token": pushToken,
        "last_active": lastActive,
        "createdAt": createdAt,
      };
}
