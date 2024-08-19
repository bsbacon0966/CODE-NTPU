import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interviewer/food_for_not_waste/food_for_not_waste.dart';
import 'package:intl/intl.dart';

import '../color_decide.dart';
import 'food_for_not_waste_detail_page.dart';

class FoodForNotWasteMainPage extends StatefulWidget {
  @override
  State<FoodForNotWasteMainPage> createState() => _FoodForNotWasteMainPageState();
}

class _FoodForNotWasteMainPageState extends State<FoodForNotWasteMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _food_for_not_waste_info;

  @override
  void initState() {
    super.initState();
    _food_for_not_waste_info = _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final querySnapshot = await _firestore.collection('your_collection').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'imageUrl': data['imageUrl'],
          'timestamp': data['timestamp'],
          'place': data['place'],
          'dataList': List<Map<String, dynamic>>.from(data['dataList'] ?? [])
        };
      }).toList();
    } catch (e) {
      print('Failed to fetch data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food for Not Waste Main Page"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => FoodForNotWaste());
              },
              child: Text("我要新增資訊"),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _food_for_not_waste_info,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                }
                final dataList = snapshot.data!;
                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      child:  GestureDetector(
                        onTap: () {
                          Get.to(() => DetailPage(
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
                                color: Colors.black, // 黑色外框
                                width: 2.0, // 外框宽度，可根据需要调整
                              ),
                            ),
                            child:Row(
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
                                                  fontSize: 40.0,
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
                                                      fontSize: 22.0,
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
                                    children:[
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
                                            fontSize: 80.0,
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
                                    ]
                                ),
                              ],
                            )
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
    );
  }
}
