

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateAppEntryCount() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference docRef = firestore.collection('app_stats').doc('usage');

  await firestore.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(docRef);

    if (!snapshot.exists) {
      transaction.set(docRef, {'total_entries': 1});
    } else {
      int currentCount = snapshot.get('total_entries');
      transaction.update(docRef, {'total_entries': currentCount + 1});
    }
  });
}