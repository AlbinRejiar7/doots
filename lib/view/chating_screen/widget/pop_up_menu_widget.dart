import 'package:doots/constants/color_constants.dart';
import 'package:flutter/material.dart';

class ChatPopupMenu extends StatelessWidget {
  const ChatPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kblack.withOpacity(0.5),
      child: PopupMenuButton<String>(
        iconColor: kWhite,
        onSelected: (String value) {
          // Handle menu item selection here
          switch (value) {
            case 'Favorite':
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
              // Handle delete option
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          'Favorite',
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
      case 'Favorite':
        return Icon(Icons.star);
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
