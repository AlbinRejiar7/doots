import 'package:doots/constants/color_constants.dart';
import 'package:doots/constants/global.dart';
import 'package:doots/controller/home_screen_controller.dart';
import 'package:doots/service/chat_services.dart';
import 'package:doots/view/auth/choose_page.dart';
import 'package:doots/view/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ChatService.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains("resume")) {
        ChatService.updateActiveStatus(true);
      }
      if (message.toString().contains("pause")) {
        ChatService.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    var c = Get.put(HomeScreenController());

    return Obx(() {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: c.isdarkmode.value ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kscaffoldDarkModColor,
              surfaceTintColor: kscaffoldDarkModColor,
            ),
            iconTheme: IconThemeData(
              color: kWhite.withOpacity(0.6),
            ),
            colorScheme: const ColorScheme.dark().copyWith(
                tertiary: kDarkModeUserChatColor,
                tertiaryContainer: kDarkModeOtherUserChatColor,
                onSecondary: kgreen1.withGreen(255),
                primary: kWhite,
                secondary: kWhite.withOpacity(0.6),
                onPrimary: kDarkModeBlack),
            dialogBackgroundColor: kscaffoldDarkModColor,
            brightness: Brightness.dark,
            primaryColor: kDarkModeBlack,
            scaffoldBackgroundColor: kscaffoldDarkModColor,
            textTheme: GoogleFonts.latoTextTheme().copyWith(
              titleLarge: TextStyle(
                fontSize: 26,
                color: kWhite.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: kWhite.withOpacity(0.6),
              ),
              bodyMedium: const TextStyle(
                color: kWhite,
              ),
            ),
          ),
          theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme().copyWith(
                  backgroundColor: kscaffoldLightModColor,
                  surfaceTintColor: kscaffoldLightModColor),
              iconTheme: IconThemeData(
                color: kblack.withOpacity(0.6),
              ),
              dialogBackgroundColor: kscaffoldLightModColor,
              scaffoldBackgroundColor: kscaffoldLightModColor,
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light().copyWith(
                  tertiary: kLightModeUserChatColor,
                  tertiaryContainer: kLightModeOtherUserChatColor,
                  onSecondary: kblack,
                  primary: kblack,
                  secondary: kblack.withOpacity(0.6),
                  onPrimary: shadedGrey),
              primaryColor: ktextfieldcolor,
              textTheme: GoogleFonts.latoTextTheme().copyWith(
                  bodyMedium: const TextStyle(
                    color: kblack,
                  ),
                  titleLarge: TextStyle(
                      color: kblack.withOpacity(0.6),
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  bodyLarge: TextStyle(
                    color: kblack.withOpacity(0.6),
                  ))),
          home: authInstance.currentUser == null
              ? const ChoosingPage()
              : const HomeScreen());
    });
  }
}
