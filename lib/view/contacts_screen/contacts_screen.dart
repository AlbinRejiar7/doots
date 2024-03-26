import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/view/contacts_screen/contacts_stream_widget.dart';
import 'package:doots/widgets/create_contact_widget.dart';
import 'package:doots/widgets/plus_card_widget.dart';
import 'package:doots/widgets/sizedboxwidget.dart';
import 'package:doots/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    var c = Get.put(ContactScreenController());
    var height = context.height;
    var width = context.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(width * 0.03, width * 0.04, width * 0.03, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contacts",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  plusCardButton(
                    height,
                    () {
                      Get.to(() => const CreateContactPage(),
                          transition: Transition.downToUp);
                    },
                  )
                ],
              ),
              kHeight(height * 0.03),
              CustomTextField(
                  onChanged: (query) => c.runfilter(query),
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  hintText: "Search Contacts.."),
              Obx(() {
                return c.noResultsFound.value
                    ? Text("No Contacts Found")
                    : ContactsStreamBuilder(c: c, height: height, width: width);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
