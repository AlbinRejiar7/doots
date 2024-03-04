import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.width,
    required this.chats,
    required this.index,
  });

  final double width;
  final List chats;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: width * 0.35),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
                color: kGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5)),
            child: Text(chats[index]['chats'],
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(DateFormat.jm().format(DateTime.now()),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
