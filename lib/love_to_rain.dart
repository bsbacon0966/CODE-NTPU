import 'package:flutter/material.dart';

class love_to_rain extends StatefulWidget {
  @override
  _love_to_rain createState() => _love_to_rain();
}

class _love_to_rain extends State<love_to_rain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('愛心傘'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/warning.png"),
          SizedBox(height: 20), // Adds spacing between the image and the texts
          Text(
            "正在施工中...此區域將會為了愛心傘而開設",
            style: TextStyle(fontSize: 18), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
          Text(
            "之後將利用此頁面告訴管理者借用愛心傘之狀況以便管理",
            style: TextStyle(fontSize: 16), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
        ],
      ),
    );
  }
}