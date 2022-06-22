import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomFloatingButton extends StatefulWidget {
  final String text;
  Color? color, fontcolor;
  double? fontsize;
  void Function()? onTap;

  CustomFloatingButton(
    this.text,
    this.color, {
    this.fontcolor,
    this.onTap,
    this.fontsize,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomFloatingButton();
  }
}

class _CustomFloatingButton extends State<CustomFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onTap,
      backgroundColor: widget.color,
      child: Text(widget.text,style: TextStyle(
        color: widget.fontcolor,
        fontSize: widget.fontsize
      ),),
    );
  }
}
