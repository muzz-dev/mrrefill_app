import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrrefill_app/model/AreaModel.dart';
import 'package:mrrefill_app/model/CartridgeModel.dart';
import 'package:mrrefill_app/model/CompanyModel.dart';
import 'package:mrrefill_app/model/ExchangeCartridgeModel.dart';
import 'package:mrrefill_app/model/MModel.dart';
import 'package:mrrefill_app/model/ProblemModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_button.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/const_widget/custom_textformfield.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:http/http.dart' as http;
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/BottomNavigation.dart';
import 'package:mrrefill_app/screens/exchange/PreviousRequestScreen.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRequestScreen extends StatefulWidget {
  const ExchangeRequestScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeRequestScreen> createState() => _ExchangeRequestScreenState();
}

class _ExchangeRequestScreenState extends State<ExchangeRequestScreen> {
  final formKey = new GlobalKey<FormState>();
  var cartridgename = new TextEditingController();
  var address = new TextEditingController();
  var remark = new TextEditingController();
  bool _isloading = false;
  DateTime? todaysdate = DateTime.now();
  String? date;

  //Company Declaration
  Future<List<CompanyModel>?>? companylistdata;
  List<String> itemsCompanyName = [];
  List<int> itemsCompanyId = [];
  String? companyName, companyId;

  //Model Declaration
  Future<List<MModel>?>? modellistdata;
  List<String> itemsModelName = [];
  List<int> itemsModelId = [];
  String? modelName, modelId;

  //Cartridge Declaration
  Future<List<CartridgeModel>?>? cartridgelistdata;
  List<String> itemsCartridgeName = [];
  List<int> itemsCartridgeId = [];
  String? cartridgeName, cartridgeId;

  //Area Declaration
  Future<List<AreaModel>?>? arealistdata;
  List<String> itemsAreaName = [];
  List<int> itemsAreaId = [];
  String? areaName, areaId;

  //Problem Declaration
  Future<List<ProblemModel>?>? problemlistdata;
  List<String> itemsProblemName = [];
  List<int> itemsProblemId = [];
  String? problemName, problemId;

  // Company Data Get
  Future<List<CompanyModel>?> getCompanyListdata() async {
    try {
      return await ApiHandler.get(UrlResources.COMPANY)
          .then((dynamic value) async {
        // print(value);
        return List<CompanyModel>.from(
            value.map((x) => CompanyModel.fromJson(x)));
      });
    } on ErrorHandler catch (ex) {
      return null;
    }
  }

  // Model Data Get
  Future<List<MModel>?> getModelListdata(companyId) async {
    try {
      return await ApiHandler.get(UrlResources.MODEL+"/ModelByCompanyId/"+companyId.toString())
          .then((dynamic value) async {
        print(value);
        return List<MModel>.from(value.map((x) => MModel.fromJson(x)));
      });
    } on ErrorHandler catch (ex) {
      return null;
    }
  }

  // Cartridge Data Get
  Future<List<CartridgeModel>?> getCartridgeListdata(modelId) async {
    try {
      return await ApiHandler.get(UrlResources.CARTRIDGE+"/CartridgeByModelId/"+modelId.toString())
          .then((dynamic value) async {
        print(value);
        return List<CartridgeModel>.from(
            value.map((x) => CartridgeModel.fromJson(x)));
      });
    } on ErrorHandler catch (ex) {
      return null;
    }
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

  // Problem Data Get
  Future<List<ProblemModel>?> getProblemListdata() async {
    try {
      return await ApiHandler.get(UrlResources.PROBLEM)
          .then((dynamic value) async {
        // print(value);
        return List<ProblemModel>.from(
            value.map((x) => ProblemModel.fromJson(x)));
      });
    } on ErrorHandler catch (ex) {
      return null;
    }
  }

  //Get Company Data
  _loadCompanyData() {
    itemsCompanyName.clear();
    itemsCompanyId.clear();
    companylistdata?.then((value) {
      // print(value);
      value!.forEach((element) {
        itemsCompanyName.add(element.companyName!);
        itemsCompanyId.add(element.companyId!);
      });
    });
  }

  //Get Model Data
  _loadModelData(companyId) {
    itemsModelName.clear();
    itemsModelId.clear();
    modellistdata = getModelListdata(companyId);
    modellistdata?.then((value) {
      // print(value);
      value!.forEach((element) {
        // print(element.modelId);
        itemsModelName.add(element.modelName!);
        itemsModelId.add(element.modelId!);
      });
    });
  }

  //Get Cartridge Data
  _loadCartridgeData(modelId) {
    itemsCartridgeName.clear();
    itemsCartridgeId.clear();
    cartridgelistdata = getCartridgeListdata(modelId);
    cartridgelistdata?.then((value) {
      // print(value);
      value!.forEach((element) {
        itemsCartridgeName.add(element.cartridgeName!);
        itemsCartridgeId.add(element.cartridgeId!);
      });
    });
  }

  //Get Area Data
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

  //Get Problem Data
  _loadProblemData() {
    itemsProblemName.clear();
    itemsProblemId.clear();
    problemlistdata?.then((value) {
      // print(value);
      value!.forEach((element) {
        itemsProblemName.add(element.problemName!);
        itemsProblemId.add(element.problemId!);
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
    companylistdata = getCompanyListdata();
    arealistdata = getAreaListdata();
    problemlistdata = getProblemListdata();
    _loadCompanyData();
    _loadAreaData();
    _loadProblemData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appbar: true,
        centerTitle: true,
        appbartitle: StringRes.exchangerequest,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              showSelectedItems: true,
                              items: itemsCompanyName,
                              compareFn: (item, selectedItem) => true,
                              selectedItem: companyName,
                              showClearButton: true,
                              hint: "Select Company",
                              validator: (val) {
                                if (val == null)
                                  return "Please Select Company";
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
                                companyId = "";
                                final index = itemsCompanyName
                                    .indexWhere((element) => element == value);
                                companyId = itemsCompanyId[index].toString();
                                // print(companyId);
                                _loadModelData(companyId);
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              showSelectedItems: true,
                              items: itemsModelName,
                              compareFn: (item, selectedItem) => true,
                              selectedItem: modelName,
                              showClearButton: true,
                              hint: "Select Model",
                              validator: (val) {
                                if (val == null)
                                  return "Please Select Model";
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
                              onChanged: (value) async {
                                modelId = "";
                                final index = itemsModelName
                                    .indexWhere((element) => element == value);

                                modelId = itemsModelId[index].toString();
                                // print(modelId);
                                _loadCartridgeData(modelId);
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              showSelectedItems: true,
                              items: itemsCartridgeName,
                              compareFn: (item, selectedItem) => true,
                              selectedItem: cartridgeName,
                              showClearButton: true,
                              hint: "Select Cartridge",
                              validator: (val) {
                                if (val == null)
                                  return "Please Select Cartridge";
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
                                cartridgeId = "";
                                final index = itemsCartridgeName
                                    .indexWhere((element) => element == value);
                                cartridgeId =
                                    itemsCartridgeId[index].toString();
                                // print(modelId);
                                setState(() {});
                              },
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              showSelectedItems: true,
                              items: itemsProblemName,
                              compareFn: (item, selectedItem) => true,
                              selectedItem: problemName,
                              showClearButton: true,
                              hint: "Select Problem",
                              validator: (val) {
                                if (val == null)
                                  return "Please Select Problem";
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
                                problemId = "";
                                final index = itemsProblemName
                                    .indexWhere((element) => element == value);
                                problemId = itemsProblemId[index].toString();
                                // print(modelId);
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: CustomButton(
                              StringRes.sendrequest,
                              ColorRes.redLight,
                              _isloading,
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (_isloading == false) {
                                  if (formKey.currentState!.validate()) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var userId = prefs.getString("userId");

                                    ExchangeCartridgeModel exchangecartridge =
                                        new ExchangeCartridgeModel(
                                            exchangeId: 0,
                                            userId:
                                                int.parse(userId.toString()),
                                            cartridgeId: int.parse(
                                                cartridgeId.toString()),
                                            address: address.text.toString(),
                                            areaId:
                                                int.parse(areaId.toString()),
                                            problemId : int.parse(problemId.toString()),
                                            status: "pending",
                                            requestDate: date.toString(),
                                            areaName: "",
                                            cartridgeName: "",
                                            employeeId: 0,
                                            employeeName: "",
                                            userName: "",
                                            createdAt: date.toString(),
                                            updatedAt: date.toString());
                                    Map<String, String> headers = {
                                      'Content-Type': 'application/json',
                                      'authorization':
                                          'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
                                    };
                                    final msg =
                                        jsonEncode(exchangecartridge.toJson());
                                    var url = Uri.parse(
                                        UrlResources.EXCHANGE_CARTRIDGE);
                                    var response = await http.post(url,
                                        headers: headers, body: msg);
                                    if (response.statusCode == 201) {
                                      var json = jsonDecode(response.body);
                                      print(json);

                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: 'Request sent successfully!!!',
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
