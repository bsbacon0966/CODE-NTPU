import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('學術表單集中區'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/warning.png"),
          SizedBox(height: 20), // Adds spacing between the image and the texts
          Text(
            "正在施工中...此區域將會為了學術表單開放",
            style: TextStyle(fontSize: 18), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
          Text(
            "之後將利用此頁面集中表單",
            style: TextStyle(fontSize: 16), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
        ],
      ),
    );
  }
}