import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/event_notify.dart';
import 'package:interviewer/login/login.dart';
import 'package:interviewer/main.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:interviewer/main_page/main_first.dart';

class NewsController extends StatefulWidget {

  @override
  State<NewsController> createState() => _NewsControllerState();
}

class _NewsControllerState extends State<NewsController> {

  bool _isUploading = false;
  StreamController<double>? _progressController;
  PlatformFile? pickedFile;
  String? downloadUrl;

  Widget TextShow(String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          info,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(color_decide[user_color_decide][3]),
          ),
        ),
        SizedBox(width: 1,),
      ],
    );
  }

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
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "沒有上傳圖片!",
      );
      return;
    }

    final path = 'news_for_everyone/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    _progressController = StreamController<double>();

    try {
      ToastService.showWarningToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "上傳中，請等到「上傳成功」，請勿離開!",
      );
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
        await saveToDatabase(downloadUrl!);
        ToastService.showSuccessToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "上傳成功!",
        );
        setState(() {
          _isUploading = false;
          pickedFile = null;
        });
        _progressController?.close();
      });
    } catch (e) {
      _progressController?.addError('Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  Future saveToDatabase(String url) async {
    try {
      await FirebaseFirestore.instance.collection('news_for_everyone').add({
        'imageUrl': url,
        'timestamp':Timestamp.now(),
      });
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

  Widget add_picture_box(BuildContext context) {
    return GestureDetector(
      onTap: selectFile,
      child: Opacity(
        opacity: 0.7,
        child: Container(
          height: MediaQuery.of(context).size.width* 0.506,
          width: MediaQuery.of(context).size.width* 0.9,
          decoration: BoxDecoration(
            color: Color(color_decide[user_color_decide][1]),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 40,
                  color: Color(color_decide[user_color_decide][3]),
                ),
                TextShow("Tap here to add an image"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: dynamicTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ADD Someting'),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(
                "上傳圖片預覽投影狀態",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(color_decide[user_color_decide][3]),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: GestureDetector(
                        onTap: selectFile,
                        child: pickedFile != null
                            ? Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.504,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(pickedFile!.path!)),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        )
                            : add_picture_box(context),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => uploadFile(context),
                      child: Text("Upload"),
                    ),
                    if (_isUploading && _progressController != null)
                      StreamBuilder<double>(
                        stream: _progressController!.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Text('Uploading... Progress: ${snapshot.data?.toStringAsFixed(2)}%'),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
