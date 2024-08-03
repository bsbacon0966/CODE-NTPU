import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviewer/event_notify.dart';
import 'package:interviewer/login/login.dart';
import 'package:interviewer/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:interviewer/main_page/main_first.dart';

import '../main_page_and_menu/main_page_and_menu_initial.dart';

final Uri _list = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScZrmPSlm5YvaDXWtbH82SD0hcWxPIzlq31NtzRLqwI-zbyYQ/viewform?usp=sf_link');
final Uri _about_me = Uri.parse('https://www.linkedin.com/in/%E5%AD%90%E5%82%91-%E9%99%B3-b93a64287/');

String schoolID_on_menu = "410085000";

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
                fontSize: 27,
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
      backgroundColor: Color(0xff739abe),
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
                          schoolID_on_menu,
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
                  Get.back(result: () => the_total_page());
                }),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu_list("問題回報", Icons.warning, () {
                  _launchUrl(_list);
                }),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu_list("關於開發者", Icons.create, () {
                  _launchUrl(_about_me);
                }),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu_list("登出", Icons.output, () async {
                  try {
                    await FirebaseFirestore.instance.terminate();
                    await FirebaseFirestore.instance.clearPersistence();
                    await FirebaseAuth.instance.signOut();
                    Future.delayed(Duration(seconds: 1), () {
                      exit(0);
                    });
                  } catch (e) {
                    print('Logout error: $e');
                  }
                }),
              ],
            ),
          )
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
