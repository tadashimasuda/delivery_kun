import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  AccountTextField({this.inputText,required this.obscureText,required this.title,required this.icon,required this.onChange});

  final String? inputText;
  final bool obscureText;
  final String title;
  final IconData icon;
  final ValueChanged onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text:inputText),
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
