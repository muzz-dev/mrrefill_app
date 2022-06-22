import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mrrefill_app/model/UserModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/const_widget/stylist_toast.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/screens/auth/RegistrationScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username = new TextEditingController();
  var password = new TextEditingController();
  bool passwordvisible = true;
  bool _isloading = false;
  final formKey = new GlobalKey<FormState>();

  _checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("isLogin"));
    if (prefs.getBool("isLogin") == true) {
      Navigator.of(context).push(PageTransition(
          child: BottomNavigation(), type: PageTransitionType.fade));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPref();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        statusbarcolor: ColorRes.redLight,
        statusbarbrightness: Brightness.dark,
        backgroundColor: ColorRes.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Container(
                color: ColorRes.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Center(
                        child: Image.asset(
                      ImageRes.logo,
                      width: 275,
                    )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: CustomTextFormField(
                        StringRes.username,
                        username,
                        inputtype: TextInputType.emailAddress,
                        hinttext: StringRes.username,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: CustomTextFormField("Password", password,
                          inputtype: TextInputType.text,
                          hinttext: "Password",
                          borderRadius: BorderRadius.circular(5),
                          obscureText: passwordvisible,
                          suffixIcon: passwordvisible
                              ? IconButton(
                                  icon: Image.asset(
                                    "assets/images/invisible.png",
                                    height: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordvisible = false;
                                    });
                                  })
                              : IconButton(
                                  icon: Image.asset(
                                    "assets/images/view.png",
                                    height: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordvisible = true;
                                    });
                                  })),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: CustomButton(
                        StringRes.login,
                        ColorRes.redLight,
                        _isloading,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          if (_isloading == false) {
                            if (formKey.currentState!.validate()) {
                              _isloading = true;
                              print(_isloading);
                              UserModel user = new UserModel(
                                  userId: 0,
                                  name: username.text.toString(),
                                  contact: "",
                                  emailId: username.text.toString(),
                                  password: password.text.toString(),
                                  companyName: "",
                                  address: "",
                                  areaId: 0,
                                  gstNumber: "",
                                  otp: "",
                                  type: "",
                                  registerBy: "",
                                  isVerify: "",
                                  isBlock: "",
                                  createdAt: "",
                                  updatedAt: "");
                              Map<String, String> headers = {
                                'Content-Type': 'application/json',
                                'authorization':
                                    'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                              };
                              final msg = jsonEncode(user.toJson());

                              var url = Uri.parse(UrlResources.AUTH);
                              var response = await http.post(url,
                                  headers: headers, body: msg);
                              if (response.body != "") {
                                if (response.statusCode == 200) {
                                  var json = jsonDecode(response.body);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("isLogin", true);
                                  prefs.setString(
                                      "userId", json["userId"].toString());
                                  prefs.setString("name", json["name"]);
                                  prefs.setString("type", json["type"]);
                                  prefs.setString("email", json["emailId"]);
                                  prefs.setString("contact", json["contact"]);
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).pop();
                                  if (prefs.getString("type") == "User") {
                                    Navigator.of(context).push(PageTransition(
                                        child: BottomNavigation(index: 0),
                                        type: PageTransitionType.fade));
                                  } else {
                                    Navigator.of(context).push(PageTransition(
                                        child: BottomNavigation(index: 1),
                                        type: PageTransitionType.fade));
                                  }
                                }
                              } else {
                                setState(() {
                                  _isloading = false;
                                });
                                styledtoast(
                                    context, "Invalid username or password");
                              }
                            }
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(
                              color: ColorRes.blackLight, fontSize: 16.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageTransition(
                                child: RegistrationScreen(),
                                type: PageTransitionType.rightToLeft));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18.0,
                              decoration: TextDecoration.underline,
                              color: ColorRes.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
