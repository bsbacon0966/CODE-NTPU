import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserDocument(UserCredential? userCredential , String schoolID)async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(userCredential?.user!.email)
      .set({
    "email":userCredential?.user!.email,
    "schoolID":schoolID,
    "favorite_hyperlink":[true, true, true, true, false, false, false, false, false, false],
    "favorite_service":[false, true, false, true, false,true],
    "personal_schedule":[],
    "user_color_decide":0,
  });
}