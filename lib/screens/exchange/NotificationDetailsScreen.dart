import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/AssignRequestModel.dart';
import 'package:mrrefill_app/model/ExchangeCartridgeModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/screens/exchange/CloseRequest.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationDetailsScreen extends StatefulWidget {
  final String? exchangeId;

  const NotificationDetailsScreen({Key? key, this.exchangeId})
      : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  DateTime? todaysdate = DateTime.now();
  final formKey = new GlobalKey<FormState>();
  ExchangeCartridgeModel? detaildata;
  bool _isloading = false;
  Future<void>? _launched;
  String _phone = '';
  String? paymentMode;
  String? date;

  List<String>? _itemList = [
    "CASH",
    "ONLINE",
  ];

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Allocated Request Details
  getExchangeCartridgedata() async {
    try {
      return await ApiHandler.get(UrlResources.EXCHANGE_CARTRIDGE +
              "AllocatedRequestDetail/" +
              widget.exchangeId.toString())
          .then((dynamic value) async {
        print(value);
        setState(() {
          detaildata = ExchangeCartridgeModel.fromJson(value);
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
    getExchangeCartridgedata();
    setState(() {
      date = DateFormat("dd-MM-yyyy'T'HH:mm:ss").format(todaysdate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbartitle: StringRes.requestdetails,
      appbar: true,
      centerTitle: true,
      body: SingleChildScrollView(
        child: (detaildata != null)
            ? Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                child: Card(
                  elevation: 5.0,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.userName.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Customer Name",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _phone = detaildata!.userContactNumber.toString();
                              _launched = _makePhoneCall('tel:$_phone');
                            });
                          },
                          title: Text(detaildata!.userContactNumber.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Contact Number",
                              style: TextStyle(fontSize: 14.0)),
                          trailing:
                              Icon(Icons.call, color: Colors.blue, size: 25),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.cartridgeName.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Cartridge Details",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.address.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle:
                              Text("Address", style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.requestDate.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Date of Request",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.datetime.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Date of Solution",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.status.toString().toUpperCase(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle:
                              Text("Status", style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(detaildata!.amount.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Payable Amount",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          title: Text(
                              detaildata!.paymentMode.toString().toUpperCase(),
                              style: TextStyle(fontSize: 18.0)),
                          subtitle: Text("Payment Mode",
                              style: TextStyle(fontSize: 14.0)),
                        ),
                        (detaildata!.status.toString() == "pending")
                            ? Padding(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide:
                                            BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                        ),
                                  ),
                                ),
                              )
                            : Visibility(
                                child: Text(""),
                                visible: false,
                              ),
                        (detaildata!.status.toString() == "pending")
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 20),
                                child: CustomButton(
                                  StringRes.respondtorequest,
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
                                              assignId: int.parse(detaildata!
                                                  .assignId
                                                  .toString()),
                                              userId: int.parse(
                                                  detaildata!.employeeId.toString()),
                                              exchangeId: int.parse(
                                                  widget.exchangeId.toString()),
                                              status: "complete",
                                              amount:
                                                  detaildata!.amount.toString(),
                                              paymentMode: paymentMode.toString(),
                                              userName: "",
                                              contactNumber: "",
                                              isPay:"Y",
                                              datetime: date.toString(),
                                              createdAt: date.toString(),
                                              updatedAt: date.toString());

                                      Map<String, String> headers = {
                                        'Content-Type': 'application/json',
                                        'authorization':
                                            'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                      };
                                      final msg =
                                          jsonEncode(assignModel.toJson());
                                      print(msg.toString());
                                      var url = Uri.parse(
                                          UrlResources.ASSIGNREQUEST +
                                              "/" +
                                              detaildata!.assignId.toString());
                                      print(url);
                                      var response = await http.put(url,
                                          headers: headers, body: msg);
                                      print(response.statusCode);
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 204) {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text:
                                                'Request Closed Successfully!!!',
                                            confirmBtnColor: ColorRes.redLight,
                                            onConfirmBtnTap: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  PageTransition(
                                                      child: BottomNavigation(
                                                          index: 1),
                                                      type: PageTransitionType
                                                          .fade),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            });
                                      }
                                    }
                                  },
                                ),
                              )
                            : Visibility(
                                child: Text(""),
                                visible: false,
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
