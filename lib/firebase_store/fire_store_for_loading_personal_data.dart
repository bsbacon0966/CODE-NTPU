import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:interviewer/personal_menu/Personal_Menu.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;
Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetail() async{
  return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
}

Future<void> updateUserHyperlink() async {
  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "favorite_hyperlink": hyper_link_is_on,
    });
  }
}

Future<void> loadUserHyperlink() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> favoriteHyperlink = doc.data()?['favorite_hyperlink'];
      hyper_link_is_on = List<bool>.from(favoriteHyperlink);
    }
  }
}

Future<void> loadUserSchoolID() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      schoolID_on_menu = doc.data()?['schoolID'];
    }
  }
}