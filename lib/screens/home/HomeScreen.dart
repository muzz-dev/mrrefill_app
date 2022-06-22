import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/screens/FeedbackScreen.dart';
import 'package:mrrefill_app/screens/auth/ChangePasswordScreen.dart';
import 'package:mrrefill_app/screens/auth/LoginScreen.dart';
import 'package:mrrefill_app/screens/auth/RegistrationScreen.dart';
import 'package:mrrefill_app/screens/exchange/ExchangeRequestScreen.dart';
import 'package:mrrefill_app/screens/exchange/PreviousRequestEmployee.dart';
import 'package:mrrefill_app/screens/exchange/PreviousRequestScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var username, email, userType;
  final List imgList = [
    'assets/images/slideshow-1.png',
    'assets/images/slideshow-2.png',
    'assets/images/slideshow-3.png',
    'assets/images/slideshow-4.png',
    'assets/images/slideshow-5.png',
    'assets/images/slideshow-6.png',
  ];

  List<Widget> _getCarausal() {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.fill, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return imageSliders;
  }

  _setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("name");
      userType = prefs.getString("type");
      email = prefs.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: true,
      centerTitle: true,
      appbartitle: StringRes.apptitle,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure want to logout?"),
                    actions: [
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("isLogin", false);
                          prefs.setString("userId", "");
                          prefs.setString("name", "");
                          prefs.setString("type", "");
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: LoginScreen(),
                                  type: PageTransitionType.fade),
                              (route) => false);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(
                Ionicons.power_outline,
                size: 25,
              )),
        )
      ],
      drawer: Drawer(
        child: Container(
          color: ColorRes.white,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(username.toString()),
                accountEmail: Text(email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/launcher.png'),
                ),
                decoration: BoxDecoration(
                  color: ColorRes.redLight,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        (userType == "User")
                            ? ListTile(
                                leading: Icon(Icons.change_circle),
                                title: Text(
                                  "Exchange Request",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(PageTransition(
                                      child: ExchangeRequestScreen(),
                                      type: PageTransitionType.fade));
                                },
                              )
                            : Visibility(child: Text(""), visible: false),
                        (userType == "User")
                            ? ListTile(
                                leading: Icon(
                                  Ionicons.cart,
                                ),
                                title: Text(
                                  "Previous Request",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(PageTransition(
                                      child: PreviousRequestScreen(),
                                      type: PageTransitionType.fade));
                                },
                              )
                            : ListTile(
                                leading: Icon(
                                  Ionicons.cart,
                                ),
                                title: Text(
                                  "Previous Request",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(PageTransition(
                                      child: PreviousRequestEmployee(),
                                      type: PageTransitionType.fade));
                                },
                              ),
                        ListTile(
                          leading: Icon(Icons.password_sharp),
                          title: Text(
                            "Change Password",
                            style: TextStyle(fontSize: 17.0),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(PageTransition(
                                child: ChangePasswordScreen(),
                                type: PageTransitionType.fade));
                          },
                        ),
                        (userType == "User")
                            ? ListTile(
                                leading: Icon(Icons.feedback_sharp),
                                title: Text(
                                  "Give Feedback",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(PageTransition(
                                      child: FeedbackScreen(),
                                      type: PageTransitionType.fade));
                                },
                              )
                            : Visibility(child: Text(""), visible: false),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            height: 300,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
          ),
          items: _getCarausal(),
        )),
      ),
    );
  }
}
