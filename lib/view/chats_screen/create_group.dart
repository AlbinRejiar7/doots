import 'package:doots/constants/color_constants.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewGroup extends StatelessWidget {
  const CreateNewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen1,
        centerTitle: true,
        title: const CustomTextWidget(
          text: "Create New Group",
          color: kWhite,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Group Name",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            kHeight(height * 0.01),
            CustomTextField(
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                isBoarder: false,
                hintText: "Enter group name"),
            kHeight(height * 0.02),
            Text(
              "Group Profile",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            kHeight(height * 0.01),
            Row(
              children: [
                SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {},
                      child: Text(
                        "Choose file",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: kWhite, fontWeight: FontWeight.bold),
                      )),
                ),
                kWidth(width * 0.02),
                Text(
                  "No file choosen",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            kHeight(height * 0.02),
            Text(
              "Group Members",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            kHeight(height * 0.01),
            SizedBox(
              width: width * 0.5,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {},
                  child: Text(
                    "Select members",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: kWhite, fontWeight: FontWeight.bold),
                  )),
            ),
            kHeight(height * 0.02),
            Text(
              "Description",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            kHeight(height * 0.02),
            CustomTextField(
                isMaxLine: true,
                maxLines: 3,
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                isBoarder: false,
                hintText: "Enter Description"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.5,
                  height: height * 0.06,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {},
                      child: Text(
                        "Create",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: kWhite, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
