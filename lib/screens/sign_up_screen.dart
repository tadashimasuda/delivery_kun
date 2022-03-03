import 'package:flutter/material.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_form_btn.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email = '';
  String password = '';
  String password_confirmation = '';

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
              AccountTextField(
                obscureText: true,
                title: '確認用パスワード',
                icon: Icons.remove_red_eye_outlined,
                onChange: (value) {
                  password_confirmation = value;
                },
              ),
              SizedBox(
                height: 40,
              ),
            ]),
          ),
          account_btn(
            title: 'アカウント登録',
            color: Colors.lightBlue,
            onTap: () {
              Map creds = {
                'email': email,
                'password': password,
                'password_confirmation': password_confirmation
              };
              Provider.of<Auth>(context, listen: false).register(creds: creds);
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text('or', textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                children: [
                  //TODO:google Icon
                  Text(
                    'Googleでログイン',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
            onTap: () {
              //TODO:Provider google login function
            },
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