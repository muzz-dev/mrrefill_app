import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomButton extends StatefulWidget {
  final String text;
  Color? color, fontcolor;
  double? fontsize;
  bool? isloading, buttoncenter;
  FontWeight? fontWeight;
  Alignment? alignment, buttonalignment;
  BorderRadius? borderRadius;
  BoxShadow? boxShadow;
  Gradient? gradient;
  EdgeInsetsGeometry? padding, margin;
  void Function()? onTap;

  CustomButton(this.text, this.color, this.isloading,
      {this.margin,
      this.gradient,
      this.buttoncenter,
      this.fontcolor,
      this.alignment,
      this.padding,
      this.onTap,
      this.boxShadow,
      this.fontsize,
      this.fontWeight,
      this.borderRadius});

  @override
  State<StatefulWidget> createState() {
    return _CustomButtonState();
  }
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return widget.buttoncenter == null
        ? widget.boxShadow != null
            ? Padding(
                padding: widget.margin == null
                    ? EdgeInsets.only(left: 10, right: 10)
                    : widget.margin!,
                child: InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    alignment: widget.alignment == null
                        ? Alignment.center
                        : widget.alignment,
                    padding: widget.padding == null
                        ? EdgeInsets.only(top: 15, bottom: 15)
                        : widget.padding,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: widget.borderRadius == null
                          ? BorderRadius.circular(0)
                          : widget.borderRadius,
                      boxShadow: [widget.boxShadow!],
                      gradient: widget.gradient == null
                          ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [widget.color!, widget.color!])
                          : widget.gradient,
                    ),
                    child: widget.isloading!
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : Text(
                            widget.text,
                            style: TextStyle(
                                color: widget.fontcolor == null
                                    ? Colors.white
                                    : widget.fontcolor,
                                fontSize: widget.fontsize == null
                                    ? 18
                                    : widget.fontsize,
                                fontWeight: widget.fontWeight == null
                                    ? FontWeight.w700
                                    : widget.fontWeight),
                          ),
                  ),
                ),
              )
            : Padding(
                padding: widget.margin == null
                    ? EdgeInsets.only(left: 20, right: 20)
                    : widget.margin!,
                child: InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    alignment: widget.alignment == null
                        ? Alignment.center
                        : widget.alignment,
                    padding: widget.padding == null
                        ? EdgeInsets.only(top: 15, bottom: 15)
                        : widget.padding,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: widget.borderRadius == null
                          ? BorderRadius.circular(0)
                          : widget.borderRadius,
                      gradient: widget.gradient == null
                          ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [widget.color!, widget.color!])
                          : widget.gradient,
                    ),
                    child: widget.isloading!
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : Text(
                            widget.text,
                            style: TextStyle(
                                color: widget.fontcolor == null
                                    ? Colors.white
                                    : widget.fontcolor,
                                fontSize: widget.fontsize == null
                                    ? 18
                                    : widget.fontsize,
                                fontWeight: widget.fontWeight == null
                                    ? FontWeight.bold
                                    : widget.fontWeight),
                          ),
                  ),
                ),
              )
        : widget.boxShadow != null
            ? InkWell(
                onTap: () => widget.onTap,
                child: Center(
                  child: Container(
                    padding: widget.padding == null
                        ? EdgeInsets.only(
                            top: 15, bottom: 15, left: 20, right: 20)
                        : widget.padding,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: widget.borderRadius == null
                          ? BorderRadius.circular(0)
                          : widget.borderRadius,
                      boxShadow: [widget.boxShadow!],
                      gradient: widget.gradient == null
                          ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [widget.color!, widget.color!])
                          : widget.gradient,
                    ),
                    child: widget.isloading!
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : Text(
                            widget.text,
                            style: TextStyle(
                                color: widget.fontcolor == null
                                    ? Colors.white
                                    : widget.fontcolor,
                                fontSize: widget.fontsize == null
                                    ? 18
                                    : widget.fontsize,
                                fontWeight: widget.fontWeight == null
                                    ? FontWeight.w400
                                    : widget.fontWeight),
                          ),
                  ),
                ),
              )
            : InkWell(
                onTap: () => widget.onTap,
                child: Center(
                  child: Container(
                    padding: widget.padding == null
                        ? EdgeInsets.only(
                            top: 15, bottom: 15, left: 20, right: 20)
                        : widget.padding,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: widget.borderRadius == null
                          ? BorderRadius.circular(0)
                          : widget.borderRadius,
                      gradient: widget.gradient == null
                          ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [widget.color!, widget.color!])
                          : widget.gradient,
                    ),
                    child: widget.isloading!
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : Text(
                            widget.text,
                            style: TextStyle(
                                color: widget.fontcolor == null
                                    ? Colors.white
                                    : widget.fontcolor,
                                fontSize: widget.fontsize == null
                                    ? 18
                                    : widget.fontsize,
                                fontWeight: widget.fontWeight == null
                                    ? FontWeight.w400
                                    : widget.fontWeight),
                          ),
                  ),
                ),
              );
  }
}
