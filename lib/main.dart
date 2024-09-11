import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/firebase_store/firebase_options.dart';
import 'package:interviewer/main_page_and_menu/Auth.dart';
import 'package:interviewer/login/login.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_store/how_many_times.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateAppEntryCount();
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color(color_decide[user_color_decide][2]),
          ),
          scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthJudge(),
    );
  }
}