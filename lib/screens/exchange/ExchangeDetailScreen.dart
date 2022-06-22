import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/AssignRequestModel.dart';
import 'package:mrrefill_app/model/ExchangeCartridgeModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/stylist_toast.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ExchangeDetailScreen extends StatefulWidget {
  final String? exchangeId;

  const ExchangeDetailScreen({Key? key, this.exchangeId}) : super(key: key);

  @override
  State<ExchangeDetailScreen> createState() => _ExchangeDetailScreenState();
}

class _ExchangeDetailScreenState extends State<ExchangeDetailScreen> {
  ExchangeCartridgeModel? detaildata;
  bool _isloading = false;
  Future<void>? _launched;
  String _phone = '';
  var userType, name, contact, email;
  late Razorpay _razorpay;
  String? date;
  DateTime? todaysdate = DateTime.now();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Exchange Request Details
  getExchangeCartridgedata() async {
    try {
      return await ApiHandler.get(UrlResources.ECDetail +
              "ExchangeDetail/Detail/" +
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

  _getPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("type");
      name = prefs.getString("name");
      email = prefs.getString("email");
      contact = prefs.getString("contact");
    });
    print(userType.toString());
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    styledtoast(context, "Payment done successfully!");
    AssignRequestModel assignModel = new AssignRequestModel(
        assignId: int.parse(detaildata!.assignId.toString()),
        userId: int.parse(detaildata!.employeeId.toString()),
        exchangeId: int.parse(widget.exchangeId.toString()),
        status: "pending",
        amount: detaildata!.amount.toString(),
        paymentMode: "ONLINE",
        userName: "",
        contactNumber: "",
        isPay: "Y",
        createdAt: detaildata!.createdAt.toString(),
        updatedAt: date.toString());

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    };
    final msg = jsonEncode(assignModel.toJson());
    var url = Uri.parse(
        UrlResources.ASSIGNREQUEST + "/" + detaildata!.assignId.toString());
    var response = await http.put(url, headers: headers, body: msg);
    print(response.statusCode);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    styledtoast(context, "Payment error!");
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getPrefrence();
    getExchangeCartridgedata();
    setState(() {
      date = DateFormat("dd-MM-yyyy'T'HH:mm:ss").format(todaysdate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: true,
      centerTitle: true,
      appbartitle: StringRes.requestdetails,
      body: SingleChildScrollView(
        child: (detaildata != null)
            ? Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                child: Card(
                  elevation: 5.0,
                  child: Column(
                    children: [
                      (userType == "User")
                          ? ListTile(
                              onTap: () {
                                setState(() {});
                              },
                              title: Text(detaildata!.employeeName.toString(),
                                  style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Employee Name",
                                  style: TextStyle(fontSize: 14.0)),
                            )
                          : ListTile(
                              onTap: () {
                                setState(() {});
                              },
                              title: Text(detaildata!.userName.toString(),
                                  style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Customer Name",
                                  style: TextStyle(fontSize: 14.0)),
                            ),
                      Divider(),
                      (userType == "User")
                          ? ListTile(
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    _phone = detaildata!.employeeContactNumber
                                        .toString();
                                    _launched = _makePhoneCall('tel:$_phone');
                                  });
                                });
                              },
                              title: Text(
                                  detaildata!.employeeContactNumber.toString(),
                                  style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Contact Number",
                                  style: TextStyle(fontSize: 14.0)),
                              trailing: Icon(Icons.call,
                                  color: Colors.blue, size: 25),
                            )
                          : ListTile(
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    _phone = detaildata!.userContactNumber
                                        .toString();
                                    _launched = _makePhoneCall('tel:$_phone');
                                  });
                                });
                              },
                              title: Text(
                                  detaildata!.userContactNumber.toString(),
                                  style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Contact Number",
                                  style: TextStyle(fontSize: 14.0)),
                              trailing: Icon(Icons.call,
                                  color: Colors.blue, size: 25),
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
                        title: (detaildata!.datetime.toString() == "" ||
                                detaildata!.datetime.toString() == null ||
                                detaildata!.datetime.toString() == "null")
                            ? Visibility(
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                visible: true,
                              )
                            : Text(detaildata!.datetime.toString(),
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
                        title: (detaildata!.isPay.toString()=="N")?Text("No",
                            style: TextStyle(fontSize: 18.0)):Text("Yes",
                            style: TextStyle(fontSize: 18.0)),
                        subtitle:
                            Text("Is Pay", style: TextStyle(fontSize: 14.0)),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {
                          setState(() {});
                        },
                        title: (detaildata!.paymentMode.toString() == "" ||
                                detaildata!.paymentMode.toString() == null ||
                                detaildata!.paymentMode.toString() == "null")
                            ? Visibility(
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                visible: true,
                              )
                            : Text(detaildata!.paymentMode.toString(),
                                style: TextStyle(fontSize: 18.0)),
                        subtitle: Text("Payment Mode",
                            style: TextStyle(fontSize: 14.0)),
                      ),
                      (detaildata!.isPay.toString() == "N")
                          ? (userType == "Employee")
                              ? Visibility(
                                  child: Text(""),
                                  visible: false,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 20),
                                  child: CustomButton(
                                    StringRes.paynow,
                                    ColorRes.redLight,
                                    _isloading,
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      var options = {
                                        'key': 'rzp_test_WoIzGoY3D973Ix',
                                        'amount': double.parse(
                                                detaildata!.amount.toString()) *
                                            100,
                                        'name': 'Mr. Refill',
                                        'retry': {
                                          'enabled': true,
                                          'max_count': 1
                                        },
                                        'send_sms_hash': true,
                                        'prefill': {
                                          'contact': contact.toString(),
                                          'email': email.toString()
                                        },
                                        'external': {
                                          'wallets': ['paytm']
                                        }
                                      };

                                      try {
                                        _razorpay.open(options);
                                      } catch (e) {
                                        debugPrint('Error: e');
                                      }
                                    },
                                  ),
                                )
                          : Visibility(
                              child: Text(""),
                              visible: false,
                            )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: ColorRes.redLight,
                ),
              ),
      ),
    );
  }
}
