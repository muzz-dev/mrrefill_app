import 'package:cool_alert/cool_alert.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/screens/exchange/NotificationScreen.dart';
import 'package:mrrefill_app/screens/auth/LoginScreen.dart';
import 'package:mrrefill_app/screens/home/HomeScreen.dart';
import 'package:mrrefill_app/screens/profile/MyProfile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  final int? index;

  const BottomNavigation({Key? key, this.index}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _page = 1;
  var userType;
  GlobalKey _bottomNavigationKey = GlobalKey();

  List<Widget> pages = [HomeScreen(), NotificationScreen(), MyProfile()];
  List<Widget> icons = [
    Icon(Icons.home, size: 30),
    Icon(Icons.notifications_active, size: 30),
    Icon(Icons.person, size: 30),
  ];

  _getOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("type");
    });
    print(pages.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _page = widget.index ?? 1;
    });
    _getOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorRes.redLight,
        height: 50,
        key: _bottomNavigationKey,
        index: _page,
        items: icons,
        animationDuration: Duration(
          milliseconds: 300,
        ),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          if (index == 1) {
            print(userType);
            if (userType == "User") {
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  text: 'Unauthorized Access!!!',
                  confirmBtnColor: ColorRes.redLight,
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                  });
            }else{
              setState(() {
                _page = index;
                print(_page);
              });
            }
          } else {
            setState(() {
              _page = index;
              print(_page);
            });
          }
        },
      ),
    );
  }
}
