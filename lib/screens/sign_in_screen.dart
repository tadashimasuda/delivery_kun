import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_form_btn.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String email='';
  String password='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'おかえりなさい！',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'ログイン',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AccountTextField(
                    obscureText: false,
                    title: 'メールアドレス',
                    icon: Icons.mail,
                    onChange: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AccountTextField(
                    obscureText: true,
                    title: 'パスワード',
                    icon: Icons.remove_red_eye_outlined,
                    onChange: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ]),
              ),
              account_btn(
                title: 'ログイン',
                color: Colors.lightBlue,
                onTap: () {
                  Map creds = {
                    'email': email,
                    'password': password,
                  };
                  Provider.of<Auth>(context, listen: false).login(creds: creds);
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ),
    );
  }
}