import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/FeedbackModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  DateTime? todaysdate = DateTime.now();
  String? date;
  TextEditingController feedback = new TextEditingController();
  bool _isloading = false;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      date = DateFormat("dd-MM-yyyy'T'HH:mm:ss").format(todaysdate!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: true,
      centerTitle: true,
      appbartitle: StringRes.feedback,
      backgroundColor: ColorRes.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                      ImageRes.feedback,
                      width: 175,
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20),
                  child: CustomTextFormField(
                    "Feedback",
                    feedback,
                    inputtype: TextInputType.multiline,
                    maxlines: 10,
                    hinttext: "Give Feedback",
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomButton(
                    StringRes.feedback,
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

                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        var userId = prefs.getString("userId");

                        FeedbackModel newFeedback = new FeedbackModel(
                          feedbackId: 0,
                          userId: int.parse(userId.toString()),
                          feedbackText: feedback.text.toString(),
                          createdAt:date.toString(),
                          updatedAt: date.toString()
                        );

                        Map<String, String> headers = {
                          'Content-Type': 'application/json',
                          'authorization':
                          'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                        };
                        final msg = jsonEncode(newFeedback.toJson());
                        var url = Uri.parse(UrlResources.FEEDBACK);
                        var response = await http.post(url,
                            headers: headers, body: msg);

                        print(response.statusCode);

                        if (response.statusCode == 201) {
                          var json = jsonDecode(response.body);
                          print(json);
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: 'Thank you for your Feedback!!!',
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
          ),
        ),
      ),
    );
  }
}
