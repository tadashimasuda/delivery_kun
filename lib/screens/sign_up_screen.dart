import 'package:delivery_kun/screens/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_form_btn.dart';
import 'package:delivery_kun/components/account_google_btn.dart';
import 'package:delivery_kun/mixins/validate_text.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with ValidateText{
  String email = '';
  String password = '';
  String passwordConfirmation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'ようこそ！',
            style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'アカウント作成',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer<Auth>(
            builder: (context, auth, child) => Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountTextField(
                      obscureText: false,
                      title: 'メールアドレス',
                      icon: Icons.mail,
                      onChange: (value) {
                        email = value;
                      },
                    ),
                    Column(
                      children: ValidateEmail(auth.validate_message),
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
                    Column(
                      children: ValidatePassword(auth.validate_message),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AccountTextField(
                      obscureText: true,
                      title: '確認用パスワード',
                      icon: Icons.remove_red_eye_outlined,
                      onChange: (value) {
                        passwordConfirmation = value;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ]
              ),
            ),
          ),
          account_btn(
            title: 'アカウント登録',
            color: Colors.lightBlue,
            onTap: () async {
              Map creds = {
                'email': email,
                'password': password,
                'password_confirmation': passwordConfirmation
              };

              bool response = await Provider.of<Auth>(context, listen: false).register(creds: creds);
              if(response){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen()));
                }
              }
          ),
          SizedBox(
            height: 20,
          ),
          Text('or', textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          GoogleAuthButton(
            title: 'Googleでログイン',
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'ログイン',
            style: TextStyle(color: Colors.lightBlue),
          )
        ]),
      ),
    ));
  }
}
