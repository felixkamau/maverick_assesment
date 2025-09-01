import 'package:flutter/material.dart';

Widget inputFields({
  bool? obscure,
  String? obscuringChar,
  bool? hasObscureInput,
  required TextEditingController controller,
  Function()? toggleInputVisibility,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
}) {
  return TextField(
    controller: controller,
    cursorColor: Colors.grey,
    cursorHeight: 20,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(15),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 3, color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromRGBO(255, 114, 94, 1),
          width: 3,
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: labelText,
      hintText: hintText,
    ),
  );
}
