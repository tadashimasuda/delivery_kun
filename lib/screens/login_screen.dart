import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                'https://media.istockphoto.com/photos/food-delivery-drivers-are-driving-to-deliver-products-to-customers-picture-id1277194125?s=612x612'),
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text('ログイン'),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width * 0.75,
                  height: 45,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'メールアドレス',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.75,
                  height: 45,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'パスワード',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: size.width * 0.75,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('ログイン'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
              width: size.width * 0.8,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD9D9D9),
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD9D9D9),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: size.width * 0.75,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Googleでログイン'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
