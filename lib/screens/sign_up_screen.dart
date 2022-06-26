import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/screens/sign_in_screen.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/account_submit_btn.dart';
import 'package:delivery_kun/mixins/validate_text.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with ValidateText {
  String name = '';
  String email = '';
  String password = '';
  String passwordConfirmation = '';
  bool isLoading = true;

  Future<bool> _handleSignInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var user = (await FirebaseAuth.instance.signInWithCredential(
            credential)).user;

        if (user?.uid != null) {
          bool isLogin = await Provider.of<Auth>(context, listen: false).OAuthLogin(
              providerName:'google',
              providerId: user!.uid,
              UserName: user.displayName,
              email: user.email,
              userImg: user.photoURL
          );

          if (isLogin) {
            return true;
          } else {
            setState(() {
              isLoading = true;
            });
            return false;
          }
        }
      }
      return false;
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

      bool isLogin = await Provider.of<Auth>(context, listen: false).OAuthLogin(
          providerName:'apple',
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
      body: isLoading
          ? SingleChildScrollView(
        child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 40, 35, 0),
                  child: Column(children: [
                    const Text(
                      'ようこそ！',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Auth>(
                      builder: (context, auth, child) => Form(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccountTextField(
                                obscureText: false,
                                title: 'ユーザ名',
                                icon: Icons.person,
                                onChange: (value) {
                                  name = value;
                                },
                              ),
                              Column(
                                children: ValidateUserName(auth.validate_message),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
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
                              const SizedBox(
                                height: 15,
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
                                children: ValidatePassword(auth.validate_message),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              AccountTextField(
                                obscureText: true,
                                title: '確認用パスワード',
                                icon: Icons.password,
                                onChange: (value) {
                                  passwordConfirmation = value;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ]),
                      ),
                    ),
                    SubmitBtn(
                        title: '新規登録',
                        color: Colors.lightBlue,
                        onTap: () async {
                          Map creds = {
                            'name': name,
                            'email': email,
                            'password': password,
                            'password_confirmation': passwordConfirmation
                          };

                          bool response =
                              await Provider.of<Auth>(context, listen: false)
                                  .register(creds: creds);
                          if (response) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MapScreen()));
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('または', textAlign: TextAlign.center),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: SocialSignInButton(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        title: 'Googleでログイン',
                        image: const DecorationImage(
                            image: NetworkImage(
                                'https://github.com/sbis04/flutterfire-samples/blob/google-sign-in/assets/google_logo.png?raw=true')),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapScreen()));
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("ログインに失敗しました。"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text("OK"),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Platform.isIOS ? GestureDetector(
                      child: SocialSignInButton(
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        title: 'Appleでログイン',
                        image: const DecorationImage(
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
                              MaterialPageRoute(builder: (context) => const MapScreen()));
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("ログインに失敗しました。"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text(
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
                    ) : const SizedBox.shrink(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInForm()));
                      },
                      child: Row(
                        children: [
                          Text(
                            'アカウントをお持ちの方は',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'ログイン',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
          )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
