
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String imageUrl;
  final String place;
  final String timestamp;
  final int totalDataNumber;
  final List<Map<String, dynamic>> dataItems;

  DetailPage({
    required this.imageUrl,
    required this.place,
    required this.timestamp,
    required this.totalDataNumber,
    required this.dataItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(imageUrl),
            Text('Place: $place'),
            Text('Timestamp: $timestamp'),
            Text('Total Quantity: $totalDataNumber'),
            ...dataItems.map((dataItem) {
              return Text('Item: ${dataItem['item_name']}, Quantity: ${dataItem['quantity']}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
