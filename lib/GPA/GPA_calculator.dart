import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:interviewer/color_decide.dart';

class CsvUploader extends StatefulWidget {
  @override
  _CsvUploaderState createState() => _CsvUploaderState();
}

class _CsvUploaderState extends State<CsvUploader> {
  List<List<dynamic>>? _csvData;
  List<List<dynamic>>? _translate;
  double total_GPA = 0;
  int total_hour = 0;
  List<String> GPA_type = ["4.3", "4.0", "5.0"];
  int _selected_type = 0;

  @override
  void initState() {
    super.initState();
  }

  Color getRowColor(int index) {
    if (index == 0) {
      return Color(color_decide[user_color_decide][2]);
    } else if (index.isEven) {
      return Colors.grey.shade100;
    } else {
      return Colors.white;
    }
  }

  double gpa_cal_4_3(int num) {
    if (num >= 90) return 4.3;
    else if (num >= 85) return 4.0;
    else if (num >= 80) return 3.7;
    else if (num >= 70) return 3.4;
    return 3.0;
  }

  double gpa_cal_4_0(int num) {
    if (num >= 80) return 4.0;
    else if (num >= 70) return 3.0;
    else if (num >= 60) return 2.0;
    return 1.0;
  }

  List<List<dynamic>> calculateGPA(List<List<dynamic>> rowData) {
    total_GPA = 0;
    total_hour = 0;

    List<List<dynamic>> ans = [];
    ans.add(["科目", "成績", "學期", "GPA"]);

    for (int i = 1; i < rowData.length; i++) {
      int grade = int.tryParse(rowData[i][1].toString()) ?? 0;
      int hours = int.tryParse(rowData[i][2].toString()) ?? 0;

      double gpa;
      if (_selected_type == 0) gpa = gpa_cal_4_3(grade);
      else gpa = gpa_cal_4_0(grade);

      ans.add([
        rowData[i][0],
        "${rowData[i][1]}($hours)",
        rowData[i][3],
        gpa
      ]);

      total_GPA += hours * gpa;
      total_hour += hours;
    }
    return ans;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        final input = await file.readAsString();
        List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);

        setState(() {
          _csvData = csvTable;
          _translate = calculateGPA(csvTable); // Calculate GPA immediately after setting _csvData
        });
      } catch (e) {
        print('Error reading file: $e');
      }
    } else {
      print('No file selected');
    }
  }

  double width_judge(int index) {
    if (index == 0) return 0.54;
    else if (index == 1) return 0.16;
    else if (index == 2) return 0.16;
    else if (index == 3) return 0.14;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.93;

    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(3, (index) {
                int day = index;
                bool isSelectedDay = _selected_type == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected_type = index;
                      if (_csvData != null) {
                        _translate = calculateGPA(_csvData!); // Recalculate GPA when type changes
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    padding: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: isSelectedDay ? Color(color_decide[user_color_decide][1]) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: isSelectedDay ? Border.all(color: Colors.black, width: 2.0) : null,
                      boxShadow: [
                        if (isSelectedDay) BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<int>(
                          value: day,
                          groupValue: _selected_type,
                          onChanged: (int? value) {
                            setState(() {
                              _selected_type = value!;
                              if (_csvData != null) {
                                _translate = calculateGPA(_csvData!); // Recalculate GPA when type changes
                              }
                            });
                          },
                          activeColor: Color(color_decide[user_color_decide][3]),
                        ),
                        Text(
                          GPA_type[day],
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Container(
              child: Text(
                "你的GPA:${(total_GPA / total_hour).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  color: Color(color_decide[user_color_decide][3]),
                ),
              ),
            ),
            if (_translate != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenWidth,
                  maxWidth: screenWidth,
                ),
                child: ListView.builder(
                  itemCount: _translate!.length,
                  itemBuilder: (context, rowIndex) {
                    List<dynamic> rowData = _translate![rowIndex];
                    return Column(
                      children: [
                        Row(
                          children: rowData.asMap().entries.map((cellEntry) {
                            int cellIndex = cellEntry.key;
                            String cellData = cellEntry.value.toString();
                            return Container(
                              width: screenWidth * width_judge(cellIndex),
                              padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 3.0),
                              decoration: BoxDecoration(
                                color: getRowColor(rowIndex),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                cellData,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Divider(height: 1.0, color: Colors.grey.shade300),
                      ],
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Upload CSV File'),
            ),
          ],
        ),
      ),
    );
  }
}
