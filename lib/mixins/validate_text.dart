import 'package:delivery_kun/models/validate.dart';
import 'package:flutter/material.dart';

mixin ValidateText{
  List<Widget> ValidateEmail(Validate? validate) {
    var email_messages = validate?.email;

    List<Widget> messages = [];
    if (email_messages != null) {
      email_messages.forEach((message) {
        messages.add(Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ));
      });
      return messages;
    }
    return messages;
  }

  List<Widget> ValidatePassword(Validate? validate) {
    var password_messages = validate?.password;

    List<Widget> messages = [];
    if (password_messages != null) {
      password_messages.forEach((message) {
        messages.add(Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ));
      });
      return messages;
    }
    return messages;
  }

  List<Widget> ValidateUserName(Validate? validate) {
    var userName = validate?.name;

    List<Widget> messages = [];
    if (userName != null) {
      userName.forEach((message) {
        messages.add(Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ));
      });
      return messages;
    }
    return messages;
  }
}