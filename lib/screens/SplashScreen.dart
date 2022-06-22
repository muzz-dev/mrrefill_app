import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/screens/auth/LoginScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool isloging;
  late BuildContext _ctx;
  var versiondetails;
  var userType;

  _checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("isLogin"));
    if (prefs.getBool("isLogin") == true) {
      setState(() {
        isloging = true;
        userType = prefs.getString("type");
      });
    } else {
      setState(() {
        isloging = false;
      });
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, Navigate);
  }

  Navigate() async {
    if (isloging) {
      if(userType=="User"){
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: BottomNavigation(index: 0),
                type: PageTransitionType.fade,
                alignment: Alignment.center,
                duration: Duration(milliseconds: 700)),
                (route) => false);
      }else{
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: BottomNavigation(index: 1),
                type: PageTransitionType.fade,
                alignment: Alignment.center,
                duration: Duration(milliseconds: 700)),
                (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: Duration(milliseconds: 700)),
          (route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPref();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
    });
    return CustomScaffold(
      statusbarcolor: ColorRes.white,
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  ImageRes.splashscreen,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CircularProgressIndicator(
                backgroundColor: ColorRes.redLight,
                valueColor: AlwaysStoppedAnimation<Color>(ColorRes.red),
              ),
            ))
      ]),
    );
  }
}
