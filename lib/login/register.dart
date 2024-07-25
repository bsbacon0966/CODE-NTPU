import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:interviewer/login/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController schoolIDController = TextEditingController();

  Future<void> createUserDocument(UserCredential? userCredential , String schoolID)async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential?.user!.email)
        .set({
          "email":userCredential?.user!.email,
          "schoolID":schoolID,
          "favorite_hyperlink":[true, true, true, true, false, false, false, false, false, false],
          "favorite_service":[false, false, false, false, false],
        });
  }

  Future<void> registerForUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (schoolIDController.text.isNotEmpty &&usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
        createUserDocument(userCredential,schoolIDController.text);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Account created successfully'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => LoginPage(), transition: Transition.rightToLeft);
                },
                child: Text('OK'),
              ),
            ],
          ),
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
    } else {
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
            TextFormField(
              controller: schoolIDController,
              decoration: InputDecoration(
                hintText: '學號(school ID)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: registerForUser,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
