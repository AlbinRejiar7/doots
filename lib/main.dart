import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/home_screen_controller.dart';
import 'package:doots/view/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var c = Get.put(HomeScreenController());

    return Obx(() {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: c.isdarkmode.value ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme().copyWith(
              backgroundColor: kscaffoldDarkModColor,
            ),
            iconTheme: IconThemeData(
              color: kWhite.withOpacity(0.6),
            ),
            colorScheme: ColorScheme.dark().copyWith(
              primary: kWhite,
              secondary: kWhite.withOpacity(0.6),
            ),
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
              bodyMedium: TextStyle(
                color: kWhite,
              ),
            ),
          ),
          theme: ThemeData.light().copyWith(
              appBarTheme: AppBarTheme().copyWith(backgroundColor: kWhite),
              iconTheme: IconThemeData(
                color: kblack.withOpacity(0.6),
              ),
              dialogBackgroundColor: kWhite,
              scaffoldBackgroundColor: kWhite,
              brightness: Brightness.light,
              colorScheme: ColorScheme.light().copyWith(
                primary: kblack,
                secondary: kblack.withOpacity(0.6),
              ),
              primaryColor: ktextfieldcolor,
              textTheme: GoogleFonts.latoTextTheme().copyWith(
                  bodyMedium: TextStyle(
                    color: kblack,
                  ),
                  titleLarge: TextStyle(
                      color: kblack.withOpacity(0.6),
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  bodyLarge: TextStyle(
                    color: kblack.withOpacity(0.6),
                  ))),
          home: SignUpScreen());
    });
  }
}
