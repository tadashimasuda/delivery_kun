import 'package:delivery_kun/models/validate.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_form_btn.dart';
import 'package:delivery_kun/components/account_google_btn.dart';
import 'package:delivery_kun/mixins/validate_text.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with ValidateText {
  String email = '';
  String password = '';
  
  @override
  Widget build(BuildContext context) {
    // return Consumer<Auth>(builder: (context, auth, child) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
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
            Consumer<Auth>(
                builder: (context, auth, child) => Form(
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        SizedBox(
                          height: 40,
                        ),
                      ]),
                )
            ),
            SubmitBtn(
              title: 'ログイン',
              color: Colors.lightBlue,
              onTap: () async {
                Map creds = {
                  'email': email,
                  'password': password,
                };
                bool response = await Provider.of<Auth>(context, listen: false)
                    .login(creds: creds);
                if (response) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapScreen()));
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 15,
            ),
            Text('or', textAlign: TextAlign.center),
            SizedBox(
              height: 15,
            ),
            GoogleAuthButton(
              title: 'Googleでログイン',
            ),
          ],
        ),
      )),
    );
    // });
  }
}
