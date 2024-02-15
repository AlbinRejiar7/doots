// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doots/view/profile_screen/profile_screen.dart';
import 'package:doots/view/settings_screen/drop_down_button_widget.dart';
import 'package:doots/view/settings_screen/expansion_tile.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileStackWidget(
              title: "Settings",
              icon: Icons.edit,
              isSettings: true,
            ),
            kHeight(height * 0.08),
            StatusDropdown(),
            Expanded(child: SettingsList()),
          ],
        ),
      ),
    );
  }
}
