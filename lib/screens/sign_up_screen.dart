import 'package:flutter/material.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email='';
  String password='';
  String password_confirmation='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value){
                    email = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                  ),
                ),
                TextField(
                  onChanged: (value){
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                  ),
                ),
                TextField(
                  onChanged: (value){
                    password_confirmation = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'パスワード確認用',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Map creds = {
                      'email': email,
                      'password': password,
                      'password_confirmation': password_confirmation
                    };
                    Provider.of<Auth>(context, listen: false).register(creds: creds);
                    Navigator.pop(context);
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
