import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../color_decide.dart';
import 'food_for_not_waste.dart';
import 'food_for_not_waste_detail_page.dart';

class FoodForNotWasteMainPage extends StatefulWidget {
  @override
  State<FoodForNotWasteMainPage> createState() => _FoodForNotWasteMainPageState();
}

class _FoodForNotWasteMainPageState extends State<FoodForNotWasteMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Define the dynamic theme
  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply the dynamic theme
      data: dynamicTheme,
      child: Scaffold(
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
                  height: MediaQuery.of(context).size.height * 0.07,
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
                      Get.to(() => FoodForNotWaste());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(color_decide[user_color_decide][3]),
                    ),
                    child: Text(
                      "我要新增資訊",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('your_collection').snapshots(),
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
                      'docID': doc.id,
                      'imageUrl': data['imageUrl'],
                      'timestamp': data['timestamp'],
                      'place': data['place'],
                      'dataList': List<Map<String, dynamic>>.from(data['dataList'] ?? [])
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      final docID = item['docID'];
                      final imageUrl = item['imageUrl'] as String?;
                      final timestamp = item['timestamp'] as Timestamp?;
                      final place = item['place'] as String?;
                      final dataItems = item['dataList'] as List<Map<String, dynamic>>?;

                      int totalDataNumber = 0;
                      if (dataItems != null) {
                        for (var dataItem in dataItems) {
                          totalDataNumber += dataItem['quantity'] as int;
                        }
                      }

                      final formattedTimestamp = timestamp != null
                          ? DateFormat('MM/dd HH:mm').format(timestamp.toDate())
                          : 'No Timestamp';

                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => DetailPage(
                              docID: docID,
                              imageUrl: imageUrl ?? '',
                              place: place ?? '',
                              timestamp: formattedTimestamp,
                              totalDataNumber: totalDataNumber,
                              dataItems: dataItems ?? [],
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            padding: EdgeInsets.all(8.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Container(
                                              child: Text(
                                                '$place',
                                                style: TextStyle(
                                                  fontSize: 34.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '上傳時間: $formattedTimestamp',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '共',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(7.0),
                                      child: Text(
                                        '$totalDataNumber',
                                        style: TextStyle(
                                          fontSize: totalDataNumber >= 10 ? 45.0 : 70.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '份',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
