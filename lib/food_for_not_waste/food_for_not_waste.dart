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
  Widget _addNewTextFormField(int index) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Row(
        children: [
          Expanded(
              child: Opacity(
                opacity: 0.7,
                child: TextFormField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    labelText: '食品資訊${index + 1}',
                    hintText: "ex:雞腿便當",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
          ),
          InputQty.int(
            maxVal: 100,
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
    if(_place.text==""){
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "請填寫地點!",
      );
      return;
    }
    else if (pickedFile == null) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "必須上傳圖片，以便同學尋找!",
      );
      return;
    }
    else if(_controllers[0].text==""||_quantities[0]==0){
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "最少必須填寫一份資訊和數量!",
      );
      return;
    }
    for(int i=0;i<_quantities.length;i++){
      if(_controllers[i].text==""){
        ToastService.showErrorToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "有資訊為空，為非法操作!",
        );
        return;
      }
      if(_quantities[i]==0){
        ToastService.showErrorToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "有資訊數量為0，為非法操作!",
        );
        return;
      }
    }
    final path = 'food_for_love/${pickedFile!.name}';
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
        'timestamp':Timestamp.now(),
        'place':_place.text,
        'dataList': datalist,
      });
    } catch (e) {
      print('Failed to save URL to database: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save URL to database: $e')));
    }
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
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width,
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
                  color: Colors.white,
                ),
                Text(
                  "Tap here to add an image",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color:Colors.white
                  ),
                ),
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
          title: Text('Food for Not Waste'),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextShow("Location"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 30.0),
                      child: Opacity(
                        opacity: 0.7,
                        child: TextFormField(
                          controller: _place,
                          decoration: InputDecoration(
                            hintText: 'Example: 商101',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextShow("Description & Quantity"),
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < how_many_textform; i++)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: _addNewTextFormField(i),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: how_many_textform>1?true:false,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child:ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  how_many_textform--;
                                  _controllers.removeLast();
                                  _quantities.removeLast();
                                });
                              },
                              child: Icon(Icons.delete_rounded),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child:ElevatedButton(
                            onPressed: () {
                              setState(() {
                                how_many_textform++;
                                _controllers.add(TextEditingController());
                                _quantities.add(0);
                              });
                            },
                            child: Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextShow("Location Picture"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: GestureDetector(
                        onTap: selectFile,
                        child: pickedFile != null
                            ? Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.file(
                              File(pickedFile!.path!),
                            ),
                          ),
                        )
                            : add_picture_box(context),
                      ),
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
