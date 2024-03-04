import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    List names = [
      'user1',
      'user2',
      'user3',
      'user4',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, width * 0.04, width * 0.03, 0),
          child: Text(
            'Calls',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/474x/98/51/1e/98511ee98a1930b8938e42caf0904d2d.jpg"),
            ),
            title: Text(
              names[index],
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "12 Feb,2024,16:28 Pm",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('0:12'),
                kWidth(width * 0.03),
                const Icon(
                  Icons.call,
                  color: kgreen1,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
