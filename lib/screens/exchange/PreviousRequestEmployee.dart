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

class PreviousRequestEmployee extends StatefulWidget {
  const PreviousRequestEmployee({Key? key}) : super(key: key);

  @override
  State<PreviousRequestEmployee> createState() =>
      _PreviousRequestEmployeeState();
}

class _PreviousRequestEmployeeState extends State<PreviousRequestEmployee> {
  Future<List<ExchangeCartridgeModel>>? previousrequestlistdata;
  bool loaded = false;

// Previous Request List
  Future<List<ExchangeCartridgeModel>> getPreviousRequestListdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    // print(userId);
    try {
      return await ApiHandler.get(UrlResources.ECDetail +
              "Employee/PreviousRequest/AllRequest/" +
              userId.toString())
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
              return (loaded)
                  ? SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1.0,
                        child: Center(
                          child: Text("No Data Available!"),
                        ),
                      ),
                    )
                  : Center(
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
                                    Navigator.of(context).push(PageTransition(
                                        child: ExchangeDetailScreen(
                                            exchangeId:
                                                data.exchangeId.toString()),
                                        curve: Curves.easeInOut,
                                        type: PageTransitionType.rightToLeft));
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
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                                "Customer Name : " +
                                                    data.userName.toString(),
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: (data.amount.toString() ==
                                                        "null" ||
                                                    data.amount.toString() ==
                                                        "" ||
                                                    data.amount.toString() ==
                                                        null)
                                                ? Text("Amount: Request pending",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ))
                                                : Text(
                                                    "Amount: \u{20B9}" +
                                                        data.amount!.toString(),
                                                    style: TextStyle(
                                                        fontSize: 18.0)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: (data.status.toString() ==
                                                    "pending")
                                                ? RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'Status: '),
                                                        TextSpan(
                                                            text: 'PENDING',
                                                            style: const TextStyle(
                                                                color: Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  )
                                                : RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'Status: '),
                                                        TextSpan(
                                                            text: 'CLOSED',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
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
        ));
  }
}
