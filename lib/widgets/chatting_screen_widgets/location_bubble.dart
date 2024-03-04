import 'package:doots/constants/color_constants.dart';
import 'package:doots/view/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LocationBubble extends StatelessWidget {
  const LocationBubble({
    super.key,
    required this.chats,
    required this.width,
    required this.height,
    required this.index,
  });

  final List chats;
  final double width;
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => MapScreen(
              currentLocation: chats[index]['chats'],
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kgreen1,
              ),
              margin: EdgeInsets.only(left: width * 0.5),
              alignment: Alignment.centerRight,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  Text("Current location "),
                ],
              ),
            ),
            Text(DateFormat.jm().format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
