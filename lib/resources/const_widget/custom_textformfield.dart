import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  TextEditingController? textEditingController;
  final String? text,label,hinttext;
  int? maxlines;
  Widget? suffixIcon;
  bool? obscureText,enabled,readOnly;
  EdgeInsets? contentPadding;
  Color? textboxfillcolor;
  BorderRadius? borderRadius;
  BorderSide? borderSide;
  int? maxLength;
  String? initialvalue;
  TextInputType? inputtype;
  TextCapitalization? textCapitalization;
  void Function(String?)? onSaved,onChanged;
  String? Function(String?)? validator;
  CustomTextFormField(this.text,this.textEditingController,{this.initialvalue,this.enabled,this.maxLength,this.inputtype,this.textCapitalization,this.suffixIcon,this.obscureText,this.readOnly,this.contentPadding,this.borderSide,this.hinttext,this.onSaved,this.validator,this.onChanged,this.borderRadius,this.label,this.maxlines,this.textboxfillcolor});
  @override
  State<StatefulWidget> createState() {
    return _CustomTextFormFieldState();
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool validator=false;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      textCapitalization: widget.textCapitalization!=null?widget.textCapitalization!:TextCapitalization.none,
      initialValue: widget.initialvalue,
      enabled: widget.enabled==null?true:widget.enabled,
      controller: widget.textEditingController,
      obscureText: widget.obscureText==null?false:widget.obscureText!,
      maxLines: widget.maxlines==null?1:widget.maxlines,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
      keyboardType: widget.inputtype==null?TextInputType.text:widget.inputtype,
      onSaved:widget.onSaved,
      onChanged:widget.onChanged,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly==null?false:true,
      validator: widget.validator==null?(val){
        if (val.toString().trim().length == 0)
        {
          setState(() {
            validator=true;
          });
          return "Please Enter ${widget.text}";
        }
        else
        {
          setState(() {
            validator=false;
          });
          return null;
        }
      }:widget.validator,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        alignLabelWithHint: true,
        hintText: widget.hinttext,
        suffixIcon: widget.suffixIcon,
        fillColor: widget.textboxfillcolor==null?Color(0xfff3f3f4):widget.textboxfillcolor,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius==null?BorderRadius.all(Radius.circular(0.0)):widget.borderRadius!,
            borderSide: widget.borderSide==null?BorderSide.none:widget.borderSide!
        ),
        border: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
            borderRadius: widget.borderRadius==null?BorderRadius.all(Radius.circular(0.0)):widget.borderRadius!,
            borderSide: widget.borderSide==null?BorderSide.none:widget.borderSide!
          //borderSide: const BorderSide(),
        ),
        //hintText: 'Mobile No'
      ),
    );
  }
}

class validator{
  static String? validateMobile(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length != 10)
      return 'Please enter Mobile Number must be of 10 digit';
    else if (!regExp.hasMatch(value))
     return 'Please enter valid mobile number';
    else
      return null;
  }
  static String? pincode(String? value) {
    String patttern = r'(^[0-9]{6}$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length != 6)
      return 'Please enter Pincode must be of 6 digit';
    else if (!regExp.hasMatch(value))
      return 'Please enter valid pincode';
    else
      return null;
  }
}