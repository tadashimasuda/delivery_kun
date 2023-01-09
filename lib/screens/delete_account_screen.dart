import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("削除してもよろしいですか？"),
      children: <Widget>[
        SimpleDialogOption(
          child: Column(children: const <Widget>[
            Text('・全ての記録が削除されます。'),
            Text('・削除されたデータ、アカウントはもとに戻すことができません。'),
            Text('上記の内容を理解しました。')
          ]),
        ),
        SimpleDialogOption(
          child: Checkbox(
              activeColor: Colors.blue,
              value: _flag,
              onChanged: (bool? e) {
                setState(() {
                  _flag = e!;
                });
              }),
        ),
        SimpleDialogOption(
          child: TextButton(
            onPressed: () async {
              if (_flag) {
                bool isDelete = await context.read<Auth>().deleteAccount();
                if (isDelete) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                }
              }
            },
            child: Text(
              'アカウントを削除します',
              style: _flag
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.grey),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
