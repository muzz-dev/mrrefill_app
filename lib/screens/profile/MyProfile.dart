import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mrrefill_app/model/UserModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/loading.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final formKey = new GlobalKey<FormState>();
  bool _isloading = false;
  UserModel? userdata;
  DateTime? todaysdate = DateTime.now();
  String? date,userType;

  var username = new TextEditingController();
  var mobilenumber = new TextEditingController();
  var email = new TextEditingController();
  var company = new TextEditingController();
  var gstNumber = new TextEditingController();
  var address = new TextEditingController();

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
        _setData();
      });
    } on ErrorHandler catch (ex) {
      return null!;
    }
  }

  _setData() {
    setState(() {
      username.text = userdata!.name.toString();
      mobilenumber.text = userdata!.contact.toString();
      email.text = userdata!.emailId.toString();
      company.text = userdata!.companyName.toString();
      gstNumber.text = userdata!.gstNumber.toString();
      address.text = userdata!.address.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdata();
    // _setData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appbar: true,
        appbartitle: StringRes.myprofile,
        centerTitle: true,
        body: Stack(
          children: [
            Scaffold(
                backgroundColor: ColorRes.white,
                body: SingleChildScrollView(
                  child: (userdata != null)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Form(
                                  key: formKey,
                                  child: Container(
                                    color: ColorRes.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            StringRes.name,
                                            username,
                                            inputtype: TextInputType.text,
                                            hinttext: StringRes.name,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            StringRes.mobileNumber,
                                            mobilenumber,
                                            maxLength: 10,
                                            inputtype: TextInputType.number,
                                            hinttext: StringRes.mobileNumber,
                                            readOnly: true,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            validator: validator.validateMobile,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            StringRes.email,
                                            email,
                                            readOnly: true,
                                            inputtype:
                                                TextInputType.emailAddress,
                                            hinttext: StringRes.email,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            StringRes.companyname,
                                            company,
                                            inputtype: TextInputType.text,
                                            hinttext: StringRes.companyname,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            StringRes.gstnumber,
                                            gstNumber,
                                            inputtype: TextInputType.text,
                                            hinttext: StringRes.gstnumber,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: CustomTextFormField(
                                            "Address",
                                            address,
                                            inputtype: TextInputType.multiline,
                                            maxlines: 4,
                                            hinttext: "Address",
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: CustomButton(
                                            StringRes.updateprofile,
                                            ColorRes.redLight,
                                            _isloading,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () async {

                                              UserModel userToUpdate = new UserModel(
                                                  userId: userdata!.userId,
                                                  name: username.text.toString(),
                                                  contact: mobilenumber.text.toString(),
                                                  emailId: email.text.toString(),
                                                  password: userdata!.password.toString(),
                                                  companyName: company.text.toString(),
                                                  address: address.text.toString(),
                                                  areaId: userdata!.areaId,
                                                  gstNumber: gstNumber.text.toString(),
                                                  type: userType.toString(),
                                                  registerBy: userdata!.registerBy.toString(),
                                                  isVerify: userdata!.isVerify.toString(),
                                                  isBlock: userdata!.isBlock.toString(),
                                                  createdAt: userdata!.createdAt.toString(),
                                                  updatedAt: date.toString());

                                              Map<String, String> headers = {
                                                'Content-Type': 'application/json',
                                                'authorization':
                                                'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                              };
                                              final msg = jsonEncode(userToUpdate.toJson());
                                              var url = Uri.parse(UrlResources.USER+"/"+ userdata!.userId.toString());
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
                                                    text: 'Profile Updated Successfully!!!',
                                                    confirmBtnColor: ColorRes.redLight,
                                                    onConfirmBtnTap: () {
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          PageTransition(
                                                              child: BottomNavigation(
                                                                  index: 2),
                                                              type: PageTransitionType
                                                                  .fade),
                                                              (Route<dynamic> route) =>
                                                          false);
                                                    });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: ColorRes.redLight,
                          ),
                        ),
                )),
            Positioned(
              child: _isloading ? Loading() : Container(),
            ),
          ],
        ));
  }
}
