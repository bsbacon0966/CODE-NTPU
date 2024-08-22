import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:interviewer/food_for_not_waste/food_for_not_waste.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../color_decide.dart';
import 'news_adjust.dart';

class NewsOverall extends StatefulWidget {
  @override
  State<NewsOverall> createState() => _NewsOverallState();
}

class _NewsOverallState extends State<NewsOverall> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> _deleteItem(String documentId, String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await _firebaseStorage.refFromURL(imageUrl).delete();
      }
      await _firestore.collection('news_for_everyone').doc(documentId).delete();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Food for Not Waste"),
        ),
        body: Column(
          children: [
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Color(color_decide[user_color_decide][3]),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        offset: Offset(5, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black, // 黑色外框
                      width: 2.0, // 外框宽度，可根据需要调整
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => NewsController());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(color_decide[user_color_decide][3]),
                    ),
                    child: Text(
                      "ADD",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Expanded(
              child:StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('news_for_everyone').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }

                  final dataList = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id, // Save the document ID
                      'imageUrl': data['imageUrl'],
                      'timestamp': data['timestamp'],
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      final documentId = item['id'] as String;
                      final imageUrl = item['imageUrl'] as String?;
                      final timestamp = item['timestamp'] as Timestamp?;

                      return GestureDetector(
                          onTap: () {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title: '資訊將刪除，是否確定?',
                              text: '確定前，上述操作皆不會被記錄',
                              confirmBtnText: '確認',
                              cancelBtnText: '取消',
                              confirmBtnColor: Colors.red,
                              onConfirmBtnTap: () async {
                                _deleteItem(documentId, imageUrl ?? '');
                              },
                              onCancelBtnTap: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.symmetric(vertical: 8.0), // Add margin between items
                          decoration: BoxDecoration(
                            color: Color(color_decide[user_color_decide][2]),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 1,
                                offset: Offset(5, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
                              if (imageUrl != null && imageUrl.isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.width * 0.514,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  color: Colors.grey[200],
                                  child: Center(child: Text('No Image Available')),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat('MM/dd HH:mm').format(timestamp!.toDate())),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
