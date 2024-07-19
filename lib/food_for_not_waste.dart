import 'package:flutter/material.dart';

class food_for_not_waste extends StatefulWidget {
  @override
  _food_for_not_waste createState() => _food_for_not_waste();
}

class _food_for_not_waste extends State<food_for_not_waste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('愛心食品'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/warning.png"),
          SizedBox(height: 20), // Adds spacing between the image and the texts
          Text(
            "正在施工中...此區域將會收集愛心便當",
            style: TextStyle(fontSize: 18), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
          Text(
            "之後將利用此頁面刊登與notify使用者(有開起通知者)有關食品的資訊",
            style: TextStyle(fontSize: 16), // Adds font size for better readability
            textAlign: TextAlign.center, // Centers the text
          ),
        ],
      ),
    );
  }
}