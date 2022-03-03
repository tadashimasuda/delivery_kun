import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  AccountTextField({required this.obscureText,required this.title,required this.icon,required this.onChange});

  final bool obscureText;
  final String title;
  final IconData icon;
  final ValueChanged onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChange,
      decoration: InputDecoration(
          suffixIcon: Icon(icon),
          labelText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}
