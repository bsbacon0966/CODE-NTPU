import 'package:flutter/material.dart';

class Schooltabletimeaddtasks extends StatefulWidget {
  final Function(List<dynamic>) onSubmit;

  Schooltabletimeaddtasks({required this.onSubmit});

  @override
  State<Schooltabletimeaddtasks> createState() => _SchooltabletimeaddtasksState();
}

class _SchooltabletimeaddtasksState extends State<Schooltabletimeaddtasks> {
  int _selectedDay = 0;
  int _selectedType = 0;
  int _selected_class_duration = 1;
  final TextEditingController _courseStartController = TextEditingController();
  final TextEditingController _courseLocationController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();

  void _handleSubmit() {
    String courseStart = _courseStartController.text;
    String courseLocation = _courseLocationController.text;
    String courseName = _courseNameController.text;

    List<dynamic> submit_tasks = [];

    // tag
    if (_selectedType == 0) {
      submit_tasks.add("課程");
    } else if (_selectedType == 1) {
      submit_tasks.add("通識");
    }

    // semester
    submit_tasks.add(1);

    // start_time & duration
    int courseStartInt = int.tryParse(courseStart) ?? 0;
    if (courseStartInt <= 4) {
      submit_tasks.add(courseStartInt + 7);
      submit_tasks.add(0);
    } else {
      submit_tasks.add(courseStartInt + 8);
      submit_tasks.add(0);
    }
    submit_tasks.add(_selected_class_duration);

    submit_tasks.add("WEEKLY"); // frequency
    submit_tasks.add(1); // frequency interval

    // 哪一天
    if (_selectedDay == 0) submit_tasks.add("MO");
    else if (_selectedDay == 1) submit_tasks.add("TU");
    else if (_selectedDay == 2) submit_tasks.add("WE");
    else if (_selectedDay == 3) submit_tasks.add("THU");
    else if (_selectedDay == 4) submit_tasks.add("FRI");

    // class_info && location
    submit_tasks.add(courseName);
    submit_tasks.add(courseLocation);

    submit_tasks.add(courseStartInt);

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
                Text(
                    "正課/通識",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
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
                      activeColor: Color(0xff739abe),
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
                Text(
                    "課程在星期幾",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
                SizedBox(width: 1,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                int day = index;
                int print_day = day+1;
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
                      activeColor: Color(0xff739abe),
                    ),
                    Text(
                      '$print_day',
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
                Text(
                    "輸入課程名稱",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
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
                          controller: _courseNameController,
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
                Text(
                    "輸入課程地點",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
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
                          controller: _courseLocationController,
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
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "課程開始在第幾堂",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
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
                          controller: _courseStartController,
                          decoration: InputDecoration(
                            hintText: '(上午第二節=>2),(下午第三節=>7),(晚上=>10)',
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
                Text(
                    "堂數",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
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
                      activeColor: Color(0xff739abe),
                    ),
                    Text(
                      '$class_duration',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child:ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  "繳交",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff739abe),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
