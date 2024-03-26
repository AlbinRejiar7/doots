class GroupChat {
  String groupId; // New field
  String groupName;
  String adminId;
  String description;
  List<String> membersId;
  String? photoUrl;

  GroupChat({
    required this.groupId, // Updated constructor
    required this.groupName,
    required this.adminId,
    required this.description,
    required this.membersId,
    this.photoUrl,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
      groupId: json['groupId'], // Parsing groupId from JSON
      groupName: json['groupName'],
      adminId: json['adminId'],
      description: json['description'],
      membersId: List<String>.from(json['membersId'] ?? []),
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId, // Including groupId in JSON output
      'groupName': groupName,
      'adminId': adminId,
      'description': description,
      'membersId': membersId,
      'photoUrl': photoUrl,
    };
  }
}
