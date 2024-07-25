import 'package:flutter/material.dart';

class Schooltabletimeaddtasks extends StatefulWidget {
  final Function(List<dynamic>) onSubmit;

  Schooltabletimeaddtasks({required this.onSubmit});

  @override
  State<Schooltabletimeaddtasks> createState() => _SchooltabletimeaddtasksState();
}

class _SchooltabletimeaddtasksState extends State<Schooltabletimeaddtasks> {
  int _selectedDay = 1;
  int _selectedType = 0;
  int _selected_class_duration = 1;

  void _handleSubmit() {
    print("Selected Type: $_selectedType");
    print("Selected Day: $_selectedDay");
    print("Selected Class Duration: $_selected_class_duration");

    List<dynamic> submit_tasks = [];
    if(_selectedType==0) submit_tasks.add("課程");
    else if(_selectedType==1)submit_tasks.add("通識");
    submit_tasks.add(1);
    submit_tasks.add(9);
    submit_tasks.add(12);
    submit_tasks.add("WEEKLY");
    submit_tasks.add(1);
    if(_selectedDay==0) submit_tasks.add("MO");
    else if(_selectedDay==1)submit_tasks.add("TU");
    else if(_selectedDay==2)submit_tasks.add("WE");
    else if(_selectedDay==3)submit_tasks.add("THU");
    else if(_selectedDay==4)submit_tasks.add("FRI");

    submit_tasks.add("測試用");
    submit_tasks.add("哈哈");

    print(submit_tasks);
    widget.onSubmit(submit_tasks);
    Navigator.pop(context);
  }

  List<String> type = ["正課", "通識"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ADD YOUR TASKS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Expanded(
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("正課/通識"),
                SizedBox(width: 1,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(type.length, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _selectedType,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                    Text(
                      type[index],
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("課程在星期幾"),
                SizedBox(width: 1,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                int day = index + 1;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: day,
                      groupValue: _selectedDay,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedDay = value!;
                        });
                      },
                    ),
                    Text(
                      '$day',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("輸入課程名稱"),
                SizedBox(width: 1,),
              ],
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: Opacity(
                        opacity: 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Example:多媒體技術與應用',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("輸入課程地點"),
                SizedBox(width: 1,),
              ],
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: Opacity(
                        opacity: 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Example:電405',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("課程開始在第幾堂"),
                SizedBox(width: 1,),
              ],
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: Opacity(
                        opacity: 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Example:(上午第二節=>2),(下午第三節=>7)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("堂數"),
                SizedBox(width: 1,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(3, (index) {
                int class_duration = index + 1;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: class_duration,
                      groupValue: _selected_class_duration,
                      onChanged: (int? value) {
                        setState(() {
                          _selected_class_duration = value!;
                        });
                      },
                    ),
                    Text(
                      '$class_duration',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
            ElevatedButton(
              onPressed: _handleSubmit, // 使用函數來處理按鈕點擊事件
              child: Text("繳交"),
            ),
          ],
        ),
      )
    );
  }
}
