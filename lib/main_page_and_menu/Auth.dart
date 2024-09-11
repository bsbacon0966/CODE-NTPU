import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviewer/login/login.dart';

import '../firebase_store/how_many_times.dart';
import 'main_page_and_menu_initial.dart';


class AuthJudge extends StatelessWidget {
  const AuthJudge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return TheBigTotalPage();
          }
          else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
