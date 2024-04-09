class ChatItem {
  String id;
  String name;
  String type; // "user" or "group"
  String imageUrl; // optional
  String? lastMessageAt; // optional
  ChatItem({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    this.lastMessageAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'imageUrl': imageUrl,
      'lastMessageAt': lastMessageAt,
    };
  }

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String,
      lastMessageAt: json['lastMessageAt'] as String?,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
