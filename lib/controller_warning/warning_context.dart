import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../color_decide.dart';

class WarningContext extends StatefulWidget {
  const WarningContext({super.key});

  @override
  State<WarningContext> createState() => _WarningContext();
}

class _WarningContext extends State<WarningContext> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );
  void deleteContext(String docID,String execute_docID){
    print(execute_docID);
    _firestore.collection('talk_to_me').doc(execute_docID).delete().then((_) {
      dismissContext(docID);
    });
  }
  void dismissContext(String docID) {
    _firestore.collection('warning_for_creater').doc(docID).delete().then((_) {
      ToastService.showSuccessToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "已解決",
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: dynamicTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text("測試服:聊天區"),
        ),
        body: Column(
          children: [
            SizedBox(height: 15,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('warning_for_creater').snapshots(),
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
                      'docID':doc.id,
                      'context_ID':data['context_ID'],
                      'context_info':data['context_info'],
                      'reportReason': data['reportReason'],
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(12.0),
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['context_info'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Flexible(
                                    child: Text(
                                      item['reportReason'] ?? 'No Context',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                      maxLines: 3, // Limit to 3 lines for content
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    dismissContext(item["docID"]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(50, 50),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Icon(
                                    Icons.disabled_by_default,
                                    color: Colors.red,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    deleteContext(item['docID'],item["context_ID"]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(50, 50),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
