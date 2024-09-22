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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food for Not Waste',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Color(color_decide[user_color_decide][2]),
        elevation: 0,
      ),
      body: Container(
        color: Color(color_decide[user_color_decide][0]),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildAddButton(),
            SizedBox(height: 20),
            Expanded(
              child: _buildFoodList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 60,
      decoration: BoxDecoration(
        color: Color(color_decide[user_color_decide][3]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => FoodForNotWaste());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(color_decide[user_color_decide][3]),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(
              "新增食物資訊",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('your_collection').orderBy('timestamp', descending: true).snapshots(),
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
            return _buildFoodItem(item);
          },
        );
      },
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> item) {
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

    return GestureDetector(
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
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(color_decide[user_color_decide][2]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$place',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formattedTimestamp,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant, color: Color(color_decide[user_color_decide][3])),
                      SizedBox(width: 10),
                      Text(
                        '可用食物',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(color_decide[user_color_decide][3]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$totalDataNumber 份',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}