import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/AreaModel.dart';
import 'package:mrrefill_app/model/UserModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/loading.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/auth/LoginScreen.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  DateTime? todaysdate = DateTime.now();
  String? date, otp;
  final formKey = new GlobalKey<FormState>();
  TextEditingController mobilenumber = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController pincode = new TextEditingController();

  bool _isloading = false;
  bool passwordvisible = true;

  //Area Declaration
  Future<List<AreaModel>?>? arealistdata;
  List<String> itemsAreaName = [];
  List<int> itemsAreaId = [];
  String? areaName, areaId;

  _setOTP() {
    Random rand = new Random();
    setState(() {
      otp = rand.nextInt(999999).toString();
    });
  }

  // Area Data Get
  Future<List<AreaModel>?> getAreaListdata() async {
    try {
      return await ApiHandler.get(UrlResources.AREA)
          .then((dynamic value) async {
        // print(value);
        return List<AreaModel>.from(value.map((x) => AreaModel.fromJson(x)));
      });
    } on ErrorHandler catch (ex) {
      return null;
    }
  }

  //Get Cartridge Data
  _loadAreaData() {
    itemsAreaName.clear();
    itemsAreaId.clear();
    arealistdata?.then((value) {
      // print(value);
      value!.forEach((element) {
        itemsAreaName.add(element.areaName!);
        itemsAreaId.add(element.areaId!);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      date = DateFormat("dd-MM-yyyy'T'HH:mm:ss").format(todaysdate!);
    });
    _setOTP();
    arealistdata = getAreaListdata();
    _loadAreaData();
    print(date);
    print(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: ColorRes.white,
            body: SafeArea(
              child: SingleChildScrollView(
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
                                  ImageRes.registration,
                                  width: 150,
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: CustomTextFormField(
                                    StringRes.name,
                                    username,
                                    inputtype: TextInputType.text,
                                    hinttext: StringRes.name,
                                    borderRadius: BorderRadius.circular(5),
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
                                    borderRadius: BorderRadius.circular(5),
                                    validator: validator.validateMobile,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: CustomTextFormField(
                                    StringRes.email,
                                    email,
                                    inputtype: TextInputType.emailAddress,
                                    hinttext: StringRes.email,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
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
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: CustomTextFormField(
                                    "Address",
                                    address,
                                    inputtype: TextInputType.multiline,
                                    maxlines: 4,
                                    hinttext: "Address",
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                    items: itemsAreaName,
                                    compareFn: (item, selectedItem) => true,
                                    selectedItem: areaName,
                                    showClearButton: true,
                                    hint: "Select Area",
                                    validator: (val) {
                                      if (val == null)
                                        return "Please Select Area";
                                      else
                                        return null;
                                    },
                                    dropdownSearchDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xfff3f3f4),
                                      contentPadding: EdgeInsets.only(
                                          left: 10, top: 5, bottom: 5),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(0.0)),
                                          borderSide:
                                          BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      areaId = "";
                                      final index = itemsAreaName
                                          .indexWhere((element) => element == value);
                                      areaId = itemsAreaId[index].toString();
                                      // print(modelId);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, bottom: 20),
                                  child: CustomButton(
                                    StringRes.registration,
                                    ColorRes.redLight,
                                    _isloading,
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      print(formKey.currentState!.validate());
                                      if (formKey.currentState!.validate()) {
                                        _isloading = true;
                                        print(_isloading);
                                        UserModel newUser = new UserModel(
                                            userId: 0,
                                            name: username.text.toString(),
                                            contact: mobilenumber.text.toString(),
                                            emailId: email.text.toString(),
                                            password: password.text.toString(),
                                            companyName: "",
                                            address: address.text.toString(),
                                            areaId: int.parse(areaId.toString()),
                                            gstNumber: "",
                                            otp: otp.toString(),
                                            type: "User",
                                            registerBy: "Online",
                                            isVerify: "N",
                                            isBlock: "N",
                                            createdAt: date.toString(),
                                            updatedAt: date.toString());

                                        print(newUser.toJson());
                                        Map<String, String> headers = {
                                          'Content-Type': 'application/json',
                                          'authorization':
                                              'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                        };
                                        final msg = jsonEncode(newUser.toJson());
                                        var url = Uri.parse(UrlResources.USER);
                                        var response = await http.post(url,
                                            headers: headers, body: msg);

                                        print(response.statusCode);

                                        if (response.statusCode == 201) {
                                          var json = jsonDecode(response.body);
                                          print(json);

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              PageTransition(
                                                  child: LoginScreen(),
                                                  type: PageTransitionType.fade),
                                              (Route<dynamic> route) => false);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Already have an Account ? ",
                                      style: TextStyle(
                                          color: ColorRes.blackLight,
                                          fontSize: 16.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(PageTransition(
                                            child: LoginScreen(),
                                            type:
                                                PageTransitionType.leftToRight));
                                      },
                                      child: Text(
                                        "Sign In",
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
                          ))
                    ],
                  ),
                ),
              ),
            )),
        Positioned(
          child: _isloading ? Loading() : Container(),
        ),
      ],
    );
  }
}
