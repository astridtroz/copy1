import 'package:flutter/material.dart';

Widget myContainer(
    {
    //   double height,
    // EdgeInsetsGeometry padding,
    // EdgeInsetsGeometry margin,
    required Widget child}) {
  return Container(
    //height: height,
    //margin: margin ?? EdgeInsets.only(left: 28, right: 28, bottom: 25),
    //padding: padding ?? EdgeInsets.fromLTRB(40, 20, 40, 10),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    // decoration: BoxDecoration(
    //   color: Colors.white,
    //   boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3.0)],
    //   borderRadius: BorderRadius.all(Radius.circular(8)),
    // ),
    child: child,
  );
}
