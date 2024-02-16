// ignore_for_file: prefer_const_constructors

import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/widgets/custom_attachement_card.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(ChattingScreenController());
    var height = context.height;
    var width = context.width;
    List<String> title = [
      'MESSAGE',
      "FAVOURITE",
      "AUDIO",
      "VIDEO",
      "ARCHIVE",
      "MUTED",
      "DELETE",
    ];
    List<IconData> myIcons = [
      Icons.chat,
      Icons.favorite_border,
      Icons.call,
      Icons.video_camera_back_rounded,
      Icons.archive_rounded,
      Icons.mic_off_outlined,
      Icons.delete_outlined
    ];
    String formattedDate = DateFormat('EEE d MMM').format(DateTime.now());
    String currentTime = DateFormat.jm().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg")),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        color: kWhite,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: kWhite,
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: kWhite, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$formattedDate,$currentTime",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: kWhite,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight(height * 0.015),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            kHeight(height * 0.015),
            SizedBox(
              height: height * 0.2,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: title.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomAttachement(
                      index: index,
                      color: Theme.of(context).primaryColor,
                      title: title[index],
                      icon: myIcons[index]);
                },
              ),
            ),
            kHeight(height * 0.015),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STATUS :",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text("hii",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  kHeight(height * 0.01),
                  Text(
                    "INFO :",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name",
                              style: Theme.of(context).textTheme.bodyLarge),
                          CircleAvatar(
                              backgroundColor: kGreen.withOpacity(0.15),
                              child: IconButton(
                                onPressed: () {
                                  c.changeEditingState();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: kgreen1,
                                  size: 15,
                                ),
                              ))
                        ],
                      ),
                      Obx(() {
                        return Visibility(
                          visible: c.isEditing.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText: "Enter name",
                                  isBoarder: false,
                                  fillColor: Theme.of(context).primaryColor,
                                  filled: true,
                                ),
                              ),
                              kWidth(width * 0.01),
                              ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.save_alt,
                                    color: kgreen1,
                                  ),
                                  label: Text(
                                    "Save",
                                  ))
                            ],
                          ),
                        );
                      }),
                      kHeight(height * 0.01),
                      Text(
                        "albin",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      kHeight(height * 0.01),
                      Text("Email",
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        "abcd@gmail.com",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      kHeight(height * 0.01),
                      Text("GROUP IN COMMON",
                          style: Theme.of(context).textTheme.bodyLarge),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      kHeight(height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MEDIA",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Show all",
                                style: TextStyle(color: kgreen1),
                              ))
                        ],
                      ),
                      kHeight(height * 0.01),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      kHeight(height * 0.01),
                      Text(
                        "ATTACHED FILES",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
