import 'package:flutter/material.dart';
import 'package:mrrefill_app/resources/color_resources.dart';

class CustomTextArea extends StatefulWidget {

  TextEditingController? textEditingController;
  final String? label, hinttext;
  int? maxlines;
  BorderRadius? borderRadius;
  void Function(String?)?validator;

  CustomTextArea(
      {this.textEditingController, this.maxlines, this.borderRadius, this.label, this.hinttext, this.validator});

  @override
  State<StatefulWidget> createState() {
    return _CustomTextArea();
  }

}

class _CustomTextArea extends State<CustomTextArea> {
  bool validator = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.textEditingController,
        maxLines: widget.maxlines,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: ColorRes.orange, width: 2.0),
            ),
            labelText: widget.label,
            hintText: widget.hinttext,
            labelStyle: TextStyle(
                color: ColorRes.black
            )
        ),
        validator: widget.validator == null ? (val) {
          if (val
              .toString()
              .trim()
              .length == 0) {
            setState(() {
              validator = true;
            });
            return "Please Enter ${widget.label}";
          }
          else {
            setState(() {
              validator = false;
            });
            return null;
          }
        } : (val) {
          widget.validator;
        },
      ),
    );
  }

}