import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_form_btn.dart';
import 'package:delivery_kun/mixins/validate_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with ValidateText {
  String email = '';
  String password = '';
  bool isLoading = true;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<bool> _handleSignInGoogle() async {
    try {
      var response = await _googleSignIn.signIn();
      if (response != null) {
        GoogleSignInAuthentication googleAuth = await response.authentication;
        String accessToken = googleAuth.accessToken.toString();

        bool isLogin = await Provider.of<Auth>(context, listen: false)
            .GoogleLogin(accessToken: accessToken);

        if (isLogin) {
          return true;
        } else {
          setState(() {
            isLoading = true;
          });
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> _handleSignInApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      String? UserName = appleCredential.familyName.toString() +
          appleCredential.givenName.toString();

      bool isLogin = await Provider.of<Auth>(context, listen: false).AppleLogin(
          UserName: UserName,
          providerId: appleCredential.userIdentifier.toString(),
          email: appleCredential.email);

      if (isLogin) {
        return true;
      } else {
        setState(() {
          isLoading = true;
        });
        return false;
      }
    } catch (error) {
      print(error);

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.fromLTRB(35, 40, 35, 0),
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
                'デリバリーくんにログイン',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<Auth>(
                  builder: (context, auth, child) => Form(
                        child: Column(
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
                                icon: Icons.password,
                                onChange: (value) {
                                  password = value;
                                },
                              ),
                              Column(
                                children:
                                    ValidatePassword(auth.validate_message),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ]),
                      )),
              SubmitBtn(
                title: 'ログイン',
                color: Colors.lightBlue,
                onTap: () async {
                  Map creds = {
                    'email': email,
                    'password': password,
                  };
                  bool response =
                      await Provider.of<Auth>(context, listen: false)
                          .login(creds: creds);
                  if (response) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapScreen()));
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text('または', textAlign: TextAlign.center),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: SocialSignInButton(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  title: 'Googleでログイン',
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://github.com/sbis04/flutterfire-samples/blob/google-sign-in/assets/google_logo.png?raw=true'),
                  ),
                ),
                onTap: () async {
                  setState(() {
                    isLoading = false;
                  });

                  bool isLogin = await _handleSignInGoogle();

                  if (isLogin) {
                    setState(() {
                      isLoading = true;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapScreen()));
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("ログインに失敗しました。"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text("OK"),
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: SocialSignInButton(
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  title: 'Appleでログイン',
                  image: DecorationImage(
                      image: AssetImage("images/apple_login.png")),
                ),
                onTap: () async {
                  setState(() {
                    isLoading = false;
                  });

                  bool isLogin = await _handleSignInApple();

                  if (isLogin) {
                    setState(() {
                      isLoading = true;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapScreen()));
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("ログインに失敗しました。"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.black),
                              ),
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpForm()));
                },
                child: Row(
                  children: [
                    Text(
                      'アカウントをお持ちでない方は',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '登録',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  SocialSignInButton(
      {required this.backgroundColor,
      required this.textColor,
      required this.title,
      required this.image});

  final Color backgroundColor;
  final Color textColor;
  final String title;
  final DecorationImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ]),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
          ),
          Container(
            width: 25,
            decoration: BoxDecoration(image: image),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
