import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
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
  late List<Map<String, dynamic>> dataItems;
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    dataItems = widget.dataItems;
    _quantities = List<int>.filled(widget.dataItems.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(color_decide[user_color_decide][2]),
        scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
        appBarTheme: AppBarTheme(
          color: Color(color_decide[user_color_decide][2]),
          elevation: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '詳細資訊',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 16),
                if (widget.imageUrl.isNotEmpty) _buildImage(),
                SizedBox(height: 24),
                _buildItemList(),
                SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(color_decide[user_color_decide][1]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.place,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "上傳於 ${widget.timestamp}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            height: 200, // Adjust this value as needed
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200, // Adjust this value as needed
            child: Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "請填寫拿取資訊",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...widget.dataItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> dataItem = entry.value;
          return _buildItemCard(index, dataItem);
        }).toList(),
      ],
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> dataItem) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dataItem['item_name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '最多可取 ${dataItem['quantity']} 個',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            InputQty.int(
              maxVal: dataItem['quantity'],
              initVal: 0,
              minVal: 0,
              steps: 1,
              onQtyChanged: (val) {
                _quantities[index] = val;
              },
              decoration: QtyDecorationProps(
                isBordered: true,
                btnColor: Color(color_decide[user_color_decide][2]),
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          '確定上傳資訊',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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