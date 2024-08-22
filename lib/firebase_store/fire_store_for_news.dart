import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewer/main_page/School_Table/SchoolTableTimeAdjustTasks.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:interviewer/personal_menu/Personal_Menu.dart';
import 'package:interviewer/main_page/main_second.dart';

import '../color_decide.dart';
import '../main_page/School_Table/SchoolTableTime.dart';
final User? currentUser = FirebaseAuth.instance.currentUser;
Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetail() async{
  return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
}

Future<void> loadNews() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('news_for_everyone')
        .orderBy('timestamp', descending: true)
        .get();

    List<String> allPictures = [];
    for (var doc in querySnapshot.docs) {
      String picture = doc.data()['imageUrl'];
      allPictures.add(picture);
    }
    picture_set = allPictures;
  } catch (e) {
    print('Failed to load pictures: $e');
  }
}


Future<void> updateNews() async {
  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "favorite_hyperlink": hyper_link_is_on,
    });
  }
}