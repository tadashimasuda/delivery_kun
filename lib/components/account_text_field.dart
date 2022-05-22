import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  AccountTextField({
    this.controller,
    required this.obscureText,
    required this.title,
    required this.icon,
    required this.onChange,
    this.isBorder = false,
    this.textInputType = TextInputType.text
  });

  final TextEditingController? controller;
  final bool obscureText;
  final String title;
  final IconData icon;
  final ValueChanged onChange;
  final bool isBorder;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      onChanged: onChange,
      decoration: InputDecoration(
          labelText: title,
          border: isBorder ? OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ) :null
      )
    );
  }
}
