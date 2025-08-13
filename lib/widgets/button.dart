import 'package:flutter/material.dart';
/*
  Button template widget to be used across the application
 */

Widget button({
  required String buttonTxt,
  required Function() onPressed,
  required TextStyle buttonTxtStyle,
  double? buttonH,
  required Color buttonColor,
  double? buttonW,
}) {
  return SizedBox(
    width: buttonW ?? 160,
    height: buttonH ?? 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(buttonTxt, style: buttonTxtStyle),
    ),
  );
}
