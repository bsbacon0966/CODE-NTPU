import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";

class FoodForNotWaste extends StatefulWidget {
  @override
  _FoodForNotWasteState createState() => _FoodForNotWasteState();
}

class _FoodForNotWasteState extends State<FoodForNotWaste> {
  PlatformFile? pickedFile;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile(BuildContext context) async {
    if (pickedFile == null) {
      print('No file selected');
      return;
    }
    final path = 'food_for_love/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    try {
      print('Starting upload...');
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;
        print('Upload progress: $progress%');
      });
      await uploadTask.whenComplete(() => print('Upload successful'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful')));
    } catch (e) {
      print('Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ],
          );
        },
      ),
    );
  }
}
