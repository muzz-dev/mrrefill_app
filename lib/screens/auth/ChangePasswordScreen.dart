import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mrrefill_app/model/UserModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/loading.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = new GlobalKey<FormState>();
  bool _isloading = false;
  var password = new TextEditingController();
  var confirmpassword = new TextEditingController();
  DateTime? todaysdate = DateTime.now();
  String? date,userType;

  UserModel? userdata;

  // Get User Data
  getUserdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("userId").toString();
      return await ApiHandler.get(UrlResources.USER + "/" + userId.toString())
          .then((dynamic value) async {
        print(value);
        setState(() {
          userdata = UserModel.fromJson(value);
          userType = prefs.getString("type");
        });
      });
    } on ErrorHandler catch (ex) {
      return null!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdata();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appbar: true,
        centerTitle: true,
        appbartitle: StringRes.changepassword,
        body: Scaffold(
            backgroundColor: ColorRes.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: Container(
                          color: ColorRes.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Image.asset(
                                    ImageRes.changepassword,
                                    width: 275,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: CustomTextFormField(
                                  StringRes.password,
                                  password,
                                  inputtype: TextInputType.text,
                                  hinttext: StringRes.password,
                                  borderRadius: BorderRadius.circular(5),
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Please Enter Password';
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: CustomTextFormField(
                                  StringRes.confirmpassword,
                                  confirmpassword,
                                  inputtype: TextInputType.text,
                                  hinttext: StringRes.confirmpassword,
                                  borderRadius: BorderRadius.circular(5),
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Please Re-enter Password';
                                    if (val != password.text) {
                                      return "Both are not matched.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: CustomButton(
                                  StringRes.changepassword,
                                  ColorRes.redLight,
                                  _isloading,
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      UserModel userToUpdate = new UserModel(
                                          userId: userdata!.userId,
                                          name: userdata!.name.toString(),
                                          contact: userdata!.contact.toString(),
                                          emailId: userdata!.emailId.toString(),
                                          password: password.text.toString(),
                                          companyName:
                                              userdata!.companyName.toString(),
                                          address: userdata!.address.toString(),
                                          areaId: userdata!.areaId,
                                          gstNumber:
                                              userdata!.gstNumber.toString(),
                                          type: userType.toString(),
                                          registerBy:
                                              userdata!.registerBy.toString(),
                                          isVerify:
                                              userdata!.isVerify.toString(),
                                          isBlock: userdata!.isBlock.toString(),
                                          createdAt:
                                              userdata!.createdAt.toString(),
                                          updatedAt: date.toString());

                                      Map<String, String> headers = {
                                        'Content-Type': 'application/json',
                                        'authorization':
                                            'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                      };
                                      final msg =
                                          jsonEncode(userToUpdate.toJson());
                                      var url = Uri.parse(UrlResources.USER +
                                          "/" +
                                          userdata!.userId.toString());
                                      var response = await http.put(url,
                                          headers: headers, body: msg);
                                      print(url);
                                      print(response.statusCode);
                                      print(msg);
                                      if (response.statusCode == 200) {
                                        var json = jsonDecode(response.body);
                                        print(json);

                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text:
                                                'Password Changed Successfully!!!',
                                            confirmBtnColor: ColorRes.redLight,
                                            onConfirmBtnTap: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  PageTransition(
                                                      child: BottomNavigation(
                                                          index: 0),
                                                      type: PageTransitionType
                                                          .fade),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }
}
