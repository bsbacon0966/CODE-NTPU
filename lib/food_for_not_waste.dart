import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:status_alert/status_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";

import 'color_decide.dart';

class FoodForNotWaste extends StatefulWidget {
  @override
  _FoodForNotWasteState createState() => _FoodForNotWasteState();
}

class _FoodForNotWasteState extends State<FoodForNotWaste> {
  bool _isUploading = false;
  StreamController<double>? _progressController;
  PlatformFile? pickedFile;
  String? downloadUrl;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      downloadUrl = null;
    });
  }

  Future uploadFile(BuildContext context) async {
    if (pickedFile == null) {
      print('No file selected');
      return;
    }
    final path = 'food_for_love/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    _progressController = StreamController<double>();

    try {
      print('Starting upload...');
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      setState(() {
        _isUploading = true;
      });
      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;
        _progressController?.add(progress);
      });
      await uploadTask.whenComplete(() async {
        downloadUrl = await ref.getDownloadURL();
        await saveUrlToDatabase(downloadUrl!);
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: 'Success',
          subtitle: '消息已更新到firebase',
          configuration: IconConfiguration(icon: Icons.done_all),
          maxWidth: 260,
        );
        setState(() {
          _isUploading = false;
          pickedFile = null;
        });
        _progressController?.close();
      });
    } catch (e) {
      print('Upload failed: $e');
      _progressController?.addError('Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  Future saveUrlToDatabase(String url) async {
    try {
      await FirebaseFirestore.instance.collection('your_collection').add({
        'imageUrl': url,
        'dataList': [0, 0, 0],
      });
      print('URL saved to database');
    } catch (e) {
      print('Failed to save URL to database: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save URL to database: $e')));
    }
  }

  @override
  void dispose() {
    _progressController?.close();
    super.dispose();
  }
  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: dynamicTheme,//動態調整結果
      child: Scaffold(
        appBar: AppBar(
          title: Text('愛心食品'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pickedFile != null)
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: selectFile,
                  child: Text("Select File"),
                ),
                ElevatedButton(
                  onPressed: () => uploadFile(context),
                  child: Text("Upload File"),
                ),
                if (_isUploading && _progressController != null)
                  StreamBuilder<double>(
                    stream: _progressController!.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text('上傳中...上傳進度: ${snapshot.data?.toStringAsFixed(2)}%'),
                            SizedBox(height: 20),
                            LinearProgressIndicator(
                              value: snapshot.data! / 100,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
              ],
            );
          },
        ),
      )
    );
  }
}
