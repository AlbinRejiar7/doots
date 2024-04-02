import 'package:cached_network_image/cached_network_image.dart';
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditingPage extends StatelessWidget {
  final ChatUser chatUser;
  const ProfileEditingPage({
    super.key,
    required this.chatUser,
  });

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    var gallaryCtr = Get.put(GallaryController());
    var profileCtr = Get.put(ProfilePageController());
    profileCtr.nameCtr.text = chatUser.name!;
    profileCtr.locationCtr.text = chatUser.location!;
    profileCtr.numberCtr.text = chatUser.phoneNumber ?? "null";
    profileCtr.statusCtr.text = chatUser.about!;

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
                                  CachedNetworkImageProvider(chatUser.image!),
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
                  controller: profileCtr.nameCtr,
                  prefix: Icon(Icons.person),
                  labelText: "Name",
                  hintText: "Enter Name",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  controller: profileCtr.locationCtr,
                  prefix: Icon(Icons.location_on),
                  labelText: "Location",
                  hintText: "Enter Location",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  controller: profileCtr.numberCtr,
                  prefix: Icon(Icons.numbers),
                  labelText: "number",
                  hintText: "Enter number",
                  isBoarder: false,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                ),
                kHeight(height * 0.03),
                CustomTextField(
                  controller: profileCtr.statusCtr,
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
                            await ChatService.updateUserData(
                                    number: profileCtr.numberCtr.text,
                                    imageFile: gallaryCtr.selectedImage.value,
                                    currentUserId: chatUser.id!,
                                    name: profileCtr.nameCtr.text,
                                    location: profileCtr.locationCtr.text,
                                    status: profileCtr.statusCtr.text)
                                .then((value) {
                              gallaryCtr.isUploading(false);
                              profileCtr.fetchUserData();
                            });
                          },
                          child: const Text(
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
