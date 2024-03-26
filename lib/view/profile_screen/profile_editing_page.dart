import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditingPage extends StatelessWidget {
  final String imageUrl;
  final String currentUserId;
  const ProfileEditingPage(
      {super.key, required this.imageUrl, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    var gallaryCtr = Get.put(GallaryController());
    var profileCtr = Get.put(ProfilePageController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(() {
                      return gallaryCtr.selectedImage.value != null
                          ? CircleAvatar(
                              radius: width * 0.2,
                              backgroundImage:
                                  FileImage(gallaryCtr.selectedImage.value!),
                            )
                          : CircleAvatar(
                              radius: width * 0.2,
                              backgroundImage:
                                  CachedNetworkImageProvider(imageUrl),
                            );
                    }),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: kgreen1,
                          child: IconButton(
                              onPressed: () {
                                gallaryCtr.selectedImage(null);
                                gallaryCtr.openGalleryPicker();
                              },
                              icon: Icon(
                                Icons.add_a_photo,
                                color: kWhite,
                              )),
                        )),
                  ],
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  prefix: Icon(Icons.person),
                  labelText: "Name",
                  hintText: "Enter Name",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  prefix: Icon(Icons.email),
                  labelText: "Email",
                  hintText: "Enter Email",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  prefix: Icon(Icons.location_on),
                  labelText: "Location",
                  hintText: "Enter Location",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  prefix: Icon(Icons.numbers),
                  labelText: "number",
                  hintText: "Enter number",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  prefix: Icon(Icons.sentiment_satisfied_alt_rounded),
                  labelText: "Status",
                  hintText: "Enter Status",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                Obx(() {
                  return gallaryCtr.isUploading.value
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kgreen1),
                          onPressed: () async {
                            gallaryCtr.isUploading(true);
                            await ChatService.uploadNewProfilePicture(
                                    currentUserId,
                                    gallaryCtr.selectedImage.value)
                                .then((value) {
                              gallaryCtr.isUploading(false);
                              profileCtr.fetchUserData();
                            });
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: kWhite),
                          ));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
