import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:status_alert/status_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import '../color_decide.dart';

class FoodForNotWaste extends StatefulWidget {
  @override
  _FoodForNotWasteState createState() => _FoodForNotWasteState();
}

class _FoodForNotWasteState extends State<FoodForNotWaste> {
  bool _isUploading = false;
  StreamController<double>? _progressController;
  PlatformFile? pickedFile;
  String? downloadUrl;
  final TextEditingController _place = TextEditingController();

  List<TextEditingController> _controllers = [TextEditingController()];
  List<int> _quantities = [0];
  int how_many_textform = 1;

  Widget SectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(color_decide[user_color_decide][3]),
        ),
      ),
    );
  }

  Widget ItemInput(int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controllers[index],
                decoration: InputDecoration(
                  labelText: '食品資訊 ${index + 1}',
                  hintText: "ex: 雞腿便當",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            InputQty.int(
              maxVal: 100,
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      downloadUrl = null;
    });
  }

  Future uploadFile(BuildContext context) async {
    if (_place.text.isEmpty) {
      _showErrorToast(context, "請填寫地點!");
      return;
    }
    if (pickedFile == null) {
      _showErrorToast(context, "必須上傳圖片，以便同學尋找!");
      return;
    }
    if (_controllers[0].text.isEmpty || _quantities[0] == 0) {
      _showErrorToast(context, "最少必須填寫一份資訊和數量!");
      return;
    }
    for (int i = 0; i < _quantities.length; i++) {
      if (_controllers[i].text.isEmpty) {
        _showErrorToast(context, "有資訊為空，為非法操作!");
        return;
      }
      if (_quantities[i] == 0) {
        _showErrorToast(context, "有資訊數量為0，為非法操作!");
        return;
      }
    }

    final path = 'food_for_love/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    _progressController = StreamController<double>();

    try {
      _showWarningToast(context, "上傳中，請等到「上傳成功」，請勿離開!");
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
        _showSuccessToast(context, "上傳成功!");
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
    List<Map<String, dynamic>> datalist = [];
    for (int i = 0; i < _quantities.length; i++) {
      datalist.add({
        'item_name': _controllers[i].text,
        'quantity': _quantities[i],
      });
    }
    try {
      await FirebaseFirestore.instance.collection('your_collection').add({
        'imageUrl': url,
        'timestamp': Timestamp.now(),
        'place': _place.text,
        'dataList': datalist,
      });
    } catch (e) {
      print('Failed to save URL to database: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save URL to database: $e')));
    }
  }

  void _showErrorToast(BuildContext context, String message) {
    ToastService.showErrorToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }

  void _showWarningToast(BuildContext context, String message) {
    ToastService.showWarningToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }

  void _showSuccessToast(BuildContext context, String message) {
    ToastService.showSuccessToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }

  @override
  void dispose() {
    _progressController?.close();
    _place.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget ImagePickerWidget() {
    return GestureDetector(
      onTap: selectFile,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(color_decide[user_color_decide][1]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: pickedFile != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(pickedFile!.path!),
            fit: BoxFit.cover,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 48,
              color: Color(color_decide[user_color_decide][3]),
            ),
            SizedBox(height: 16),
            Text(
              "Click to add an image",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(color_decide[user_color_decide][3]),
              ),
            ),
          ],
        ),
      ),
    );
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
        data: dynamicTheme,
        child:Scaffold(
          appBar: AppBar(
            title: Text(
                'Food for Not Waste',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle("Location"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _place,
                    decoration: InputDecoration(
                      hintText: 'Example: 商101',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SectionTitle("Description & Quantity"),
                for (int i = 0; i < how_many_textform; i++) ItemInput(i),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (how_many_textform > 1)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                how_many_textform--;
                                _controllers.removeLast();
                                _quantities.removeLast();
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Remove Item",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      if (how_many_textform > 1) SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              how_many_textform++;
                              _controllers.add(TextEditingController());
                              _quantities.add(0);
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Add Item",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SectionTitle("Location Picture"),
                ImagePickerWidget(),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => uploadFile(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "確定結果",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isUploading && _progressController != null)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: StreamBuilder<double>(
                      stream: _progressController!.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Text(
                                'Uploading... Progress: ${snapshot.data?.toStringAsFixed(2)}%',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: snapshot.data! / 100,
                                minHeight: 10,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                SizedBox(height: 24),
              ],
            ),
          ),
        )
    );
  }
}