import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/document_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DocumentBubble extends StatelessWidget {
  const DocumentBubble({
    super.key,
    required this.width,
    required this.documentCtr,
    required this.chats,
    required this.height,
    required this.index,
  });

  final double width;
  final DocumentController documentCtr;
  final List chats;
  final double height;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: width * 0.4),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          documentCtr.openFile(chats[index]['chats']);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.03),
              decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Container(
                    height: height * 0.04,
                    width: height * 0.04,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/icons/new-document.png"))),
                    child: Center(
                      child: Text(chats[index]["extension"],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 11)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chats[index]['fileName'],
                            style: Theme.of(context).textTheme.bodyMedium),
                        Row(
                          children: [
                            Text(chats[index]['size'],
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text("•",
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(chats[index]['extension'],
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
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
