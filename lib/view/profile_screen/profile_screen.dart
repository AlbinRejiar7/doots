import 'package:doots/view/profile_screen/profile_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileStackWidget(
              title: 'My Profile',
              icon: Icons.more_vert,
            ),
            kHeight(height * 0.08),
            Text("name",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.7))),
            Text("developer", style: Theme.of(context).textTheme.bodyLarge),
            Divider(
              thickness: 0.2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("undefined",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  kHeight(height * 0.05),
                  Row(
                    children: [
                      Icon(Icons.person_outline),
                      kWidth(width * 0.04),
                      Text("name",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  kHeight(height * 0.05),
                  Row(
                    children: [
                      Icon(Icons.chat_rounded),
                      kWidth(width * 0.04),
                      Text("email",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  kHeight(height * 0.05),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      kWidth(width * 0.04),
                      Text("location",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  kHeight(height * 0.05),
                  Divider(
                    thickness: 0.2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
