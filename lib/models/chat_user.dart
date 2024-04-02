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
  String? pushToken;
  String? lastActive;
  String? createdAt;
  String? phoneNumber;
  bool? isPhotoOn; // New field added
  bool? isLastSeenOn; // New field added
  bool? isReadReceiptOn; // New field added
  String nickName; // Updated field

  ChatUser({
    this.id,
    this.name,
    this.email,
    this.location,
    this.image,
    this.about,
    this.isOnline,
    this.pushToken,
    this.lastActive,
    this.createdAt,
    this.phoneNumber,
    this.isPhotoOn = true,
    this.isLastSeenOn = true,
    this.isReadReceiptOn = true,
    this.nickName = '', // Initialize nickName with empty string
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        location: json["location"],
        image: json["image"],
        about: json["about"],
        isOnline: json["is_online"],
        pushToken: json["push_token"],
        lastActive: json["last_active"],
        createdAt: json["createdAt"],
        phoneNumber: json["phoneNumber"],
        isPhotoOn: json["is_photo_on"],
        isLastSeenOn: json["is_last_seen_on"],
        isReadReceiptOn: json["is_read_receipt_on"],
        nickName: json["nickName"] ??
            '', // Parse nickName from the JSON, default to empty string
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "location": location,
        "image": image,
        "about": about,
        "is_online": isOnline,
        "push_token": pushToken,
        "last_active": lastActive,
        "createdAt": createdAt,
        "phoneNumber": phoneNumber,
        "is_photo_on": isPhotoOn,
        "is_last_seen_on": isLastSeenOn,
        "is_read_receipt_on": isReadReceiptOn,
        "nickName": nickName, // Include nickName in the JSON
      };
}
