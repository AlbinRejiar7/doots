import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileStackWidget extends StatelessWidget {
  final String title;
  final bool isSettings;
  final IconData icon;
  const ProfileStackWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Container(
      height: height * 0.23,
      width: width,
      padding: EdgeInsets.all(width * 0.036),
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://officesnapshots.com/wp-content/uploads/2023/05/dp-world-offices-london-16-700x467-compact.jpg'))),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: title,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ],
          ),
          Align(
            alignment: Alignment(0, height * 0.0045),
            child: CircleAvatar(
              radius: width * 0.132,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
              child: CircleAvatar(
                radius: width * 0.13,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: CircleAvatar(
                  radius: width * 0.12,
                  backgroundImage: const NetworkImage(
                      "https://i.pinimg.com/474x/98/51/1e/98511ee98a1930b8938e42caf0904d2d.jpg"),
                  child: isSettings
                      ? Align(
                          alignment: Alignment(width * 0.003, height * 0.0015),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              size: 17,
                              Icons.camera_alt,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
