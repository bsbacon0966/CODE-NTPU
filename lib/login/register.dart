import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:interviewer/login/login.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../firebase_store/Create_User_Document_When_Register_Success.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController schoolIDController = TextEditingController();
  final TextEditingController passwordconfirmationController = TextEditingController();

  Widget TextField(String info,TextEditingController controller_info,bool isobscure){ // 輸入和統一規格
    return TextFormField(
      controller: controller_info,
      decoration: InputDecoration(
        hintText: info,
        border: OutlineInputBorder(),
      ),
      obscureText: isobscure
    );
  }

  Future<void> registerForUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if(schoolIDController.text.isEmpty||schoolIDController.text.length!=9){
      Navigator.pop(context);
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "請輸入正確學號",
      );
    }
    else if(usernameController.text.isEmpty){
      Navigator.pop(context);
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "請輸入你的Email",
      );
    }
    else if (schoolIDController.text.isNotEmpty &&usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && passwordconfirmationController.text.isNotEmpty) {
      if (passwordController.text != passwordconfirmationController.text) {
        Navigator.pop(context);
        ToastService.showErrorToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "密碼與確認密碼對不上",
        );
      }
      else{
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usernameController.text,
            password: passwordController.text,
          );
          createUserDocument(userCredential,schoolIDController.text); // go to "Create_User_Document_When_Register_Success"
          Navigator.pop(context);
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "帳號創立成功",
          );
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(e.message ?? 'An unknown error occurred'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
    else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('school ID , email , password cannot be empty'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField("學號(school ID)",schoolIDController,false),
            SizedBox(height: 16),
            TextField("Email",usernameController,false),
            SizedBox(height: 16),
            TextField("Password",passwordController,true),
            SizedBox(height: 16),
            TextField("Password Confirmation",passwordconfirmationController,true),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 60,
              child: ElevatedButton(
                onPressed: registerForUser,
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff739abe),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginPage(), transition: Transition.rightToLeft);
                  },
                  child: Text(
                    " Login here!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff739abe),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
