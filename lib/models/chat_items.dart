class ChatItem {
  final String id;
  final String name;
  final String type; // "user" or "group"
  final String imageUrl; // optional
  final String? lastMessageAt; // optional

  const ChatItem({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    this.lastMessageAt,
  });
}
