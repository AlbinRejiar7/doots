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
  });

  final double width;
  final double height;
  final List<String> title;
  final List<IconData> myIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: title.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomAttachement(
              index: index,
              color: kgreen1.withOpacity(0.2),
              title: title[index],
              icon: myIcons[index]);
        },
      ),
    );
  }
}
