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
  bool? isPhotoOn;
  bool? isLastSeenOn;
  bool? isReadReceiptOn;
  String nickName;
  List<String> groupIds; // Updated field with an empty list as default

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
    this.nickName = '',
    List<String>? groupIds, // Updated to allow null input for groupIds
  }) : groupIds = groupIds ??
            []; // Initialize groupIds with an empty list if not provided

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
        nickName: json["nickName"] ?? '',
        groupIds: json["groupIds"] != null
            ? List<String>.from(json["groupIds"])
            : [], // Parse groupIds from the JSON or initialize with an empty list
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
        "nickName": nickName,
        "groupIds": groupIds, // Include groupIds in the JSON
      };
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatUser && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
