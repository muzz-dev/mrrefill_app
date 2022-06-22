import 'package:flutter/material.dart';
import 'package:mrrefill_app/model/ExchangeCartridgeModel.dart';
import 'package:mrrefill_app/resources/color_resources.dart';
import 'package:mrrefill_app/resources/const_widget/custom_scaffold.dart';
import 'package:mrrefill_app/resources/string_resources.dart';
import 'package:mrrefill_app/resources/url_resources.dart';
import 'package:mrrefill_app/screens/exchange/NotificationDetailsScreen.dart';
import 'package:mrrefill_app/utils/api_handler.dart';
import 'package:mrrefill_app/utils/error_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<ExchangeCartridgeModel>>? exchangecartridgelistdata;
  bool loaded = false;

// Allocated Request List
  Future<List<ExchangeCartridgeModel>> getExchangeCartridgeListdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    // print(userId);
    try {
      return await ApiHandler.get(UrlResources.EXCHANGE_CARTRIDGE +
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
    exchangecartridgelistdata = getExchangeCartridgeListdata();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: true,
      centerTitle: true,
      appbartitle: StringRes.allocatedrequest,
      body: ListView(padding: EdgeInsets.only(bottom: 70.0), children: [
        FutureBuilder<List<ExchangeCartridgeModel>>(
          future: exchangecartridgelistdata,
          builder: (context, snapshot) {
            // print(snapshot.error);
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
              shrinkWrap: true,
              children: snapshot.data!
                  .map((data) => Container(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(PageTransition(
                                child: NotificationDetailsScreen(exchangeId: data.exchangeId.toString()),
                                curve: Curves.easeInOut,
                                // duration: Duration(milliseconds: 600),
                                type: PageTransitionType.fade));
                          },
                          child: Card(
                              elevation: 5.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Container(
                                child: ListTile(
                                    title: new Text(
                                        data.userName.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            fontSize: 18.0,
                                            color: Colors.black)),
                                    subtitle: new Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        new Align(
                                            alignment: Alignment.centerLeft,
                                            child: new Text(
                                                data.address.toString(),
                                                style: TextStyle(
                                                    letterSpacing: 0.5,
                                                    fontSize: 15.0,
                                                    color:
                                                        Colors.blueGrey))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        new Align(
                                          alignment: Alignment.centerRight,
                                          child: new Text(
                                              data.requestDate.toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w400,
                                                  letterSpacing: 0.5,
                                                  fontSize: 10.0,
                                                  color: Colors.black)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )),
                              )),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ]),
    );
  }
}
