import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../color_decide.dart';
import 'food_for_not_waste_main_page.dart';

class DetailPage extends StatefulWidget {
  final String docID;
  final String imageUrl;
  final String place;
  final String timestamp;
  final int totalDataNumber;
  final List<Map<String, dynamic>> dataItems;

  DetailPage({
    required this.docID,
    required this.imageUrl,
    required this.place,
    required this.timestamp,
    required this.totalDataNumber,
    required this.dataItems,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<TextEditingController> _controllers;
  late List<Map<String, dynamic>> dataItems;
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    dataItems = widget.dataItems;
    _quantities = List<int>.filled(widget.dataItems.length, 0);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.place} 上傳於${widget.timestamp}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Color(color_decide[user_color_decide][3]),
                ),
              ),
              if (widget.imageUrl.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image.network(widget.imageUrl),
                    ),
                  ],
                ),
              Text(
                "請填寫拿取資訊",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Color(color_decide[user_color_decide][3]),
                ),
              ),
              ...widget.dataItems.asMap().entries.map((entry) { //太扯了居然能這樣寫
                int index = entry.key;
                Map<String, dynamic> dataItem = entry.value;
                return Padding(
                    padding: EdgeInsets.all(5.0),
                    child:Container(
                      decoration: BoxDecoration(
                        color: Color(color_decide[user_color_decide][1]),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child:Text(
                                  '物件${index}:${dataItem['item_name']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(color_decide[user_color_decide][3]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child:Text(
                                  '(最多取${dataItem['quantity']})',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(color_decide[user_color_decide][3]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InputQty.int(
                                maxVal:dataItem['quantity'] ,
                                initVal: 0,
                                minVal: 0,
                                steps: 1,
                                onQtyChanged: (val) {
                                  _quantities[index] = val;
                                },
                                decoration: QtyDecorationProps(
                                  isBordered: false,
                                  borderShape: BorderShapeBtn.circle,
                                  iconColor: Color(color_decide[user_color_decide][3]),
                                  width: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                );
              }).toList(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  '確定上傳資訊',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
  Future<void> _showConfirmationDialog(BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: '確認資料是否正確?',
      text: '確定前，上述操作皆不會被記錄',
      confirmBtnText: '確認',
      cancelBtnText: '取消',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        _decrementQuantitiesAndUpdate(context);
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _decrementQuantitiesAndUpdate(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;

    List<Map<String, dynamic>> updatedDataItems = widget.dataItems.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> dataItem = entry.value;
      int decrementValue = _quantities[index];
      int updatedQuantity = (dataItem['quantity'] as int) - decrementValue;
      return {
        'item_name': dataItem['item_name'],
        'quantity': updatedQuantity < 0 ? 0 : updatedQuantity,
      };
    }).where((item) => item['quantity'] > 0).toList();

    try {
      if (updatedDataItems.isEmpty) {
        if (widget.imageUrl.isNotEmpty) {
          final imageRef = storage.refFromURL(widget.imageUrl);
          await imageRef.delete();
        }
        await firestore.collection('your_collection').doc(widget.docID).delete();
        Get.to(() => FoodForNotWasteMainPage());
      } else {
        await firestore.collection('your_collection').doc(widget.docID).update({
          'dataList': updatedDataItems,
          'timestamp': Timestamp.now(),
        });
        Get.to(() => FoodForNotWasteMainPage());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantities or delete document: $e')),
      );
    }
  }
}
