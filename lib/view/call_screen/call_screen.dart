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
        title: Text(
          'Calls',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(),
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
                Text('0:12'),
                kWidth(width * 0.03),
                Icon(
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
