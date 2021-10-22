import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? Function(String? val)? validator;
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  CustomTextField(
      {this.validator,
      this.controller,
      this.hintText = "",
      this.obscureText = false});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blueGrey[500]!,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      obscureText: obscureText,
    );
  }
}
