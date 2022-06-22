import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:mrrefill_app/resources/image_resources.dart';
import 'package:mrrefill_app/resources/text_style.dart';

class CustomScaffold extends StatefulWidget {

  final Widget? body,drawer,bottomSheet,floatingActionButton,leading;
  final Color? backgroundColor,appbarBackgroundColor,statusbarcolor;
  final Brightness? statusbarbrightness;
  final String? appbartitle;
  final bool? centerTitle,appbar,onlybrightness,bottomnavigation;
  final List<Widget>? actions;

  const CustomScaffold({
    Key? key,
    @required this.body,
    this.drawer,
    this.bottomSheet,
    this.floatingActionButton,
    this.backgroundColor,
    this.leading,
    this.appbarBackgroundColor,
    this.appbartitle,
    this.centerTitle,
    this.bottomnavigation,
    this.actions, this.appbar, this.statusbarcolor, this.statusbarbrightness, this.onlybrightness
  }) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {

  bool isOffline=false;

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }
  changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
      if (useWhiteForeground(color)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: widget.appbar!=null?AppBar(
        title: Text(widget.appbartitle!,style: TextStyleRes.AppbarTitleTextstyle,),
        centerTitle: widget.centerTitle,
        actions: widget.actions,
        leading: widget.leading,
        backgroundColor: widget.appbarBackgroundColor,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ):null,
      drawer: widget.drawer,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      body: isOffline?nointernetconnection():widget.body,
    );
  }
  Widget nointernetconnection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Image.asset(ImageRes.logo,width: 300,)
          ),
          SizedBox(height: 40,),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No Internet Connection",style: TextStyleRes.AppbarTextstyle),
          ),
          // SizedBox(height: 20,),
          // Button("Try again",Colors.red,isloading,buttoncenter: true,borderRadius: BorderRadius.circular(30),boxShadow: BoxShadow(color: Colors.grey,blurRadius: 5),)
        ],
      ),
    );
  }
}
