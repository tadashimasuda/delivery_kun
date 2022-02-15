import 'package:flutter/material.dart';

class slideSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(
              children: [
                ElevatedButton(
                  child: const Text('×1.0'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[50],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('×1.1'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[100],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('×1.2'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[200],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('×1.3'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[300],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('×1.4'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[400],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('×1.5'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    primary: Colors.red[500],
                    onPrimary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300, //横幅
            height: 50, //高さ
            child: ElevatedButton(
              onPressed: () {},
              child: Text('配達を開始する'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white30, //ボタンの背景色
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
