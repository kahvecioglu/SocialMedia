import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscuretext;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscuretext});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscuretext,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
