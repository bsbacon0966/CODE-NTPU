import 'package:flutter/material.dart';

class event_notify extends StatefulWidget {
  @override
  _event_notify createState() => _event_notify();
}

class _event_notify extends State<event_notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('活動宣傳'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/warning.png"),
          SizedBox(height: 20), // Adds spacing between the image and the texts
          Text(
            "正在施工中...此區域將會為了活動宣傳而開設",
            style: TextStyle(fontSize: 18), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
        ],
      ),
    );
  }
}