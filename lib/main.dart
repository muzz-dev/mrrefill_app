import 'package:flutter/material.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringRes.appname,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: ColorRes.redLight),
        scaffoldBackgroundColor: ColorRes.white,
        visualDensity:VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}