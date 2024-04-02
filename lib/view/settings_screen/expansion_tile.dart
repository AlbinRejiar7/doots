import 'package:doots/constants/color_constants.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return StreamBuilder(
        stream: ChatService.getMyUserData(),
        builder: (context, snapshot) {
          final myData = snapshot.data;
          return ListView(
            children: [
              MyExpansionTile(
                title: 'Personal Info',
                icon: Icons.person,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                CustomTextWidget(
                                  text: myData?.name ?? "loading...",
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            ),
                          ],
                        ),
                        kHeight(height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            CustomTextWidget(
                              text: myData?.email ?? "loading...",
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                        kHeight(height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            CustomTextWidget(
                              text: myData?.location ?? "loading..",
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                        kHeight(height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            CustomTextWidget(
                              text: myData?.phoneNumber ?? "loading..",
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                        kHeight(height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            CustomTextWidget(
                              text: myData?.about ?? "loading...",
                              fontWeight: FontWeight.w600,
                            ),
                            kHeight(height * 0.02)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // MyExpansionTile(
              //   title: 'Themes',
              //   icon: Icons.color_lens,
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             'CHOOSE THEME COLOR :',
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyLarge!
              //                 .copyWith(fontSize: 13),
              //           ),
              //           kHeight(height * 0.02),
              //           ColorPicker(),
              //           kHeight(height * 0.02),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              StreamBuilder(
                  stream: ChatService.getMyUserData(),
                  builder: (context, snapshot) {
                    var chatUser = snapshot.data;
                    bool? isProfilephoto = false;
                    bool? isLastSeen = false;
                    bool? isReadreceipt = false;
                    if (chatUser != null) {
                      isProfilephoto = chatUser.isPhotoOn;
                      isLastSeen = chatUser.isLastSeenOn;
                      isReadreceipt = chatUser.isReadReceiptOn;
                    }

                    return MyExpansionTile(
                      title: 'Privacy',
                      icon: Icons.privacy_tip,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * 0.03),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile Photo",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                      activeColor: kgreen1,
                                      value: isProfilephoto ?? false,
                                      onChanged: (value) =>
                                          ChatService.isProfilePhotoVisibile(
                                              value))
                                ],
                              ),
                              kHeight(height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Last Seen",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                      activeColor: kgreen1,
                                      value: isLastSeen ?? false,
                                      onChanged: (value) {
                                        ChatService.isLastSeenVisible(value);
                                      })
                                ],
                              ),
                              kHeight(height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Read receipts",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                      activeColor: kgreen1,
                                      value: isReadreceipt ?? false,
                                      onChanged: (value) {
                                        ChatService.isReadOn(value);
                                      })
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
              MyExpansionTile(
                title: 'Security',
                icon: Icons.security,
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Show security notification",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Switch(
                                activeColor: kgreen1,
                                value: true,
                                onChanged: (a) {})
                          ],
                        ),
                        kHeight(height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "notification sound",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Switch(
                                activeColor: kgreen1,
                                value: true,
                                onChanged: (a) {})
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MyExpansionTile(
                title: 'Help',
                icon: Icons.help,
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "FAQs",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        kHeight(height * 0.02),
                        Row(
                          children: [
                            Text(
                              "Contacts",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        kHeight(height * 0.02),
                        Row(
                          children: [
                            Text(
                              "Terms & privacy policy",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}

class MyExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const MyExpansionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: children,
    );
  }
}
