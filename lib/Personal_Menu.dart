import 'package:flutter/material.dart';
import 'package:interviewer/event_notify.dart';
import 'package:interviewer/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

final Uri _list = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScZrmPSlm5YvaDXWtbH82SD0hcWxPIzlq31NtzRLqwI-zbyYQ/viewform?usp=sf_link');

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Widget menu_list(String name, IconData icon, VoidCallback onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "您好,",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "411100000",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu_list("個人設定", Icons.settings, () {
                  Get.to(() => event_notify());
                }),
                menu_list("返回", Icons.home, () {
                  Get.back(result: () => TheBigTotalPage());
                }),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu_list("問題回報", Icons.warning, () {
                  _launchUrl(_list);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(Uri links) async {
  if (!await launchUrl(links)) {
    throw Exception('Could not launch $links');
  }
}
