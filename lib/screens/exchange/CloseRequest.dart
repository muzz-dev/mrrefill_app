import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/AssignRequestModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/const_widget/stylist_toast.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/loading.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class CloseRequest extends StatefulWidget {
  final String? assignId;
  final String? userId;
  final String? exchangeId;

  const CloseRequest({Key? key, this.assignId, this.userId, this.exchangeId})
      : super(key: key);

  @override
  State<CloseRequest> createState() => _CloseRequestState();
}

class _CloseRequestState extends State<CloseRequest> {
  DateTime? todaysdate = DateTime.now();
  final formKey = new GlobalKey<FormState>();
  bool _isloading = false;
  var amount = new TextEditingController();
  String? paymentMode;
  String? date;

  List<String>? _itemList = [
    "CASH",
    "ONLINE",
  ];

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
        appbartitle: StringRes.closerequest,
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
                          SizedBox(
                            height: 75,
                          ),
                          Center(
                              child: Image.asset(
                            ImageRes.logo,
                            width: 250,
                          )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: CustomTextFormField(StringRes.amount, amount,
                                inputtype: TextInputType.number,
                                hinttext: StringRes.amount,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: DropdownButtonFormField(
                              hint: Text("Select Payment Mode"),
                              items: _itemList!
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  paymentMode = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val == null)
                                  return "Select Payment Mode";
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff3f3f4),
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 15, bottom: 15, right: 10),
                                border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: CustomButton(
                              StringRes.submit,
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
                                  AssignRequestModel assignModel =
                                      new AssignRequestModel(
                                          assignId: int.parse(
                                              widget.assignId.toString()),
                                          userId: int.parse(
                                              widget.userId.toString()),
                                          exchangeId: int.parse(
                                              widget.exchangeId.toString()),
                                          status: "complete",
                                          amount: amount.text.toString(),
                                          paymentMode: paymentMode.toString(),
                                          userName: "",
                                          contactNumber: "",
                                          datetime: date.toString(),
                                          createdAt: date.toString(),
                                          updatedAt: date.toString());

                                  Map<String, String> headers = {
                                    'Content-Type': 'application/json',
                                    'authorization':
                                        'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                  };
                                  final msg = jsonEncode(assignModel.toJson());
                                  print(msg.toString());
                                  var url = Uri.parse(
                                      UrlResources.ASSIGNREQUEST +
                                          "/" +
                                          widget.assignId.toString());
                                  print(url);
                                  var response = await http.put(url,
                                      headers: headers, body: msg);
                                  print(response.statusCode);
                                  if (response.statusCode == 200 ||
                                      response.statusCode == 204) {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: 'Request Closed Successfully!!!',
                                        confirmBtnColor: ColorRes.redLight,
                                        onConfirmBtnTap: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              PageTransition(
                                                  child: BottomNavigation(
                                                      index: 1),
                                                  type:
                                                      PageTransitionType.fade),
                                              (Route<dynamic> route) => false);
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
        ));
  }
}
