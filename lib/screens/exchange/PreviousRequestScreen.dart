import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mrrefill_app/model/ExchangeCartridgeModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/exchange/ExchangeDetailScreen.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousRequestScreen extends StatefulWidget {
  const PreviousRequestScreen({Key? key}) : super(key: key);

  @override
  State<PreviousRequestScreen> createState() => _PreviousRequestScreenState();
}

class _PreviousRequestScreenState extends State<PreviousRequestScreen> {
  Future<List<ExchangeCartridgeModel>>? previousrequestlistdata;
  bool loaded = false;

// Previous Request List
  Future<List<ExchangeCartridgeModel>> getPreviousRequestListdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    // print(userId);
    try {
      return await ApiHandler.get(
              UrlResources.ECDetail + "MyRequests/" + userId.toString())
          .then((dynamic value) async {
        print(value);
        final items = value.cast<Map<String, dynamic>>();
        List<ExchangeCartridgeModel> listofusers =
            items.map<ExchangeCartridgeModel>((json) {
          return ExchangeCartridgeModel.fromJson(json);
        }).toList();
        List<ExchangeCartridgeModel> revdata = listofusers.toList();
        setState(() {
          loaded = true;
        });
        return revdata;
      });
    } on ErrorHandler catch (ex) {
      return null!;
      //styledtoast(context, ex.getMessage());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    previousrequestlistdata = getPreviousRequestListdata();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: true,
      centerTitle: true,
      appbartitle: StringRes.previousrequest,
      body: FutureBuilder<List<ExchangeCartridgeModel>>(
        future: previousrequestlistdata,
        builder: (context, snapshot) {
          print(snapshot.error);
          if (!snapshot.hasData) {
            return (loaded)?SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.0,
                child: Center(
                  child: Text("No Data Available!"),
                ),
              ),
            ):Center(
              child: CircularProgressIndicator(
                color: ColorRes.redLight,
              ),
            );
          }
          return ListView(
            children: snapshot.data!
                .map((data) => Container(
                      child: InkWell(
                        onTap: () {},
                        child: Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if(data.assignId == 0||data.assignId==""){
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        text: 'Employee Not Allocated Yet!!!',
                                        confirmBtnColor: ColorRes.redLight,
                                        onConfirmBtnTap: () {
                                          Navigator.of(context).pop();
                                        });
                                  }else{
                                    Navigator.of(context).push(PageTransition(
                                        child: ExchangeDetailScreen(exchangeId: data.exchangeId.toString()),
                                        curve: Curves.easeInOut,
                                        type: PageTransitionType.rightToLeft));
                                  }
                                },
                                child: Card(
                                  shape: BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 6.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                              "Request Date : " +
                                                  data.requestDate!.toString(),
                                              style: TextStyle(fontSize: 18.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: (data.employeeName
                                                          .toString() ==
                                                      "null" ||
                                                  data.employeeName
                                                          .toString() ==
                                                      "" ||
                                                  data.employeeName
                                                          .toString() ==
                                                      null)
                                              ? Text(
                                                  "Employee Name : Not Allocated",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ))
                                              : Text(
                                                  "Employee Name : " +
                                                      data.employeeName
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                              "Cartridge Name : " +
                                                  data.cartridgeName.toString(),
                                              style: TextStyle(fontSize: 18.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
