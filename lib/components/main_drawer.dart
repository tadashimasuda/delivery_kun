import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class mainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.only(top: 50.0),
      children: [
        Column(children: [
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("User Email"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80"),
            ),
          ),
        ]),
        ListTile(
          title: const Text('Login'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInForm(),
                ));
          },
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
