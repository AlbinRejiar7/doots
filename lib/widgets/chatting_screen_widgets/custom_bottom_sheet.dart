import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/custom_attachement_card.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.myIcons,
    required this.groupId,
    required this.chatUserId,
  });
  final String chatUserId;
  final double width;
  final double height;
  final List<String> title;
  final List<IconData> myIcons;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      height: height * 0.3,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: title.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomAttachement(
              groupId: groupId ?? "",
              chatUserId: chatUserId,
              index: index,
              color: kgreen1.withOpacity(0.2),
              title: title[index],
              icon: myIcons[index]);
        },
      ),
    );
  }
}
