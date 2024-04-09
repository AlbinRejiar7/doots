import 'package:doots/constants/color_constants.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/chating_screen/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatPopupMenu extends StatelessWidget {
  final String? chatId;
  const ChatPopupMenu({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kblack.withOpacity(0.5),
      child: PopupMenuButton<String>(
        iconColor: kWhite,
        onSelected: (String value) {
          // Handle menu item selection here
          switch (value) {
            case 'Pin':
              break;
            case 'Audio':
              // Handle audio option
              break;
            case 'Video':
              // Handle video option
              break;
            case 'Archive':
              // Handle archive option
              break;
            case 'Mute':
              // Handle mute option
              break;
            case 'Delete':
              showDialogeWidget(
                  context: context,
                  onPressedTick: () {
                    if (chatId != null) {
                      ChatService.clearChat(chatId!, context);
                    } else {
                      Fluttertoast.showToast(msg: "chatiD is null");
                    }
                  },
                  title: "You are about to clear the chats");
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          'Pin',
          'Audio',
          'Video',
          'Archive',
          'Mute',
          'Delete',
        ].map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: ListTile(
              leading: _getIcon(item),
              title: Text(item),
            ),
          );
        }).toList(),
      ),
    );
  }

  Icon _getIcon(String item) {
    switch (item) {
      case 'Pin':
        return Icon(Icons.push_pin);
      case 'Audio':
        return Icon(Icons.mic);
      case 'Video':
        return Icon(Icons.videocam);
      case 'Archive':
        return Icon(Icons.archive);
      case 'Mute':
        return Icon(Icons.volume_off);
      case 'Delete':
        return Icon(Icons.delete);
      default:
        return Icon(Icons.error);
    }
  }
}
