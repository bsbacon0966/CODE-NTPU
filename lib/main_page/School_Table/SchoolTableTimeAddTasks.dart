import 'package:flutter/material.dart';
import 'package:interviewer/color_decide.dart';

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
  int _selected_class_type = 0;
  int _selected_class_start_morning = 0;
  int _selected_class_start_afternoon = 0;

  final TextEditingController _courseLocationController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();

  void _handleSubmit() {

    String courseLocation = _courseLocationController.text;
    String courseName = _courseNameController.text;

    List<dynamic> submit_tasks = [];

    // "type"
    if (_selectedType == 0) {
      submit_tasks.add("課程");
    } else if (_selectedType == 1) {
      submit_tasks.add("通識");
    }

    // semester
    submit_tasks.add(1);

    // start_hour
    int courseStartInt = 0;
    if(_selected_class_type==0){
      courseStartInt+=1;
      courseStartInt+=_selected_class_start_morning;
      submit_tasks.add(courseStartInt+7);
    }
    else if(_selected_class_type==1){
      courseStartInt+=5;
      courseStartInt+=_selected_class_start_afternoon;
      submit_tasks.add(courseStartInt+8);
    }
    else{
      courseStartInt+=10;
      submit_tasks.add(courseStartInt);
    }

    //"start_minute"
    submit_tasks.add(0);

    //"duration_hours"
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

  Widget TextShow(String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          info,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(color_decide[0][3]),
          ),
        ),
        SizedBox(width: 1,),
      ],
    );
  }
  List<String> type = ["正課", "通識"];
  List<String> class_type = ["上午", "下午" , "晚上"];

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
            Text(
                "正課/通識",
              style: TextStyle(
                color:Color(color_decide[user_color_decide][3]),
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
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
                      activeColor: Color(color_decide[user_color_decide][3]),
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
            Text(
                "課程在星期幾",
              style: TextStyle(
                color:Color(color_decide[user_color_decide][3]),
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
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
                      activeColor: Color(color_decide[user_color_decide][3]),
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
            Text(
                "輸入課程名稱",
              style: TextStyle(
                color:Color(color_decide[user_color_decide][3]),
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
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
            Text(
                "輸入課程地點",
              style: TextStyle(
                color:Color(color_decide[user_color_decide][3]),
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
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
            Text(
                "課程開始在",
              style: TextStyle(
                color:Color(color_decide[user_color_decide][3]),
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(class_type.length, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _selected_class_type,
                      onChanged: (int? value) {
                        setState(() {
                          _selected_class_type = value!;
                        });
                      },
                      activeColor: Color(color_decide[user_color_decide][3]),
                    ),
                    Text(
                      class_type[index],
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 10,),
            Visibility(
              visible: _selected_class_type==2?false:true,
                child: Text(
                    "在第幾堂開始",
                  style: TextStyle(
                    color:Color(color_decide[user_color_decide][3]),
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
            ),
            Visibility(
              visible: _selected_class_type==0?true:false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (index) {
                  int class_start = index;
                  int print_class_start = class_start+1;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: class_start,
                        groupValue: _selected_class_start_morning,
                        onChanged: (int? value) {
                          setState(() {
                            _selected_class_start_morning = value!;
                          });
                        },
                        activeColor: Color(color_decide[user_color_decide][3]),
                      ),
                      Text(
                        '$print_class_start',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Visibility(
              visible: _selected_class_type==1?true:false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  int class_start = index;
                  int print_class_start = class_start+1;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: class_start,
                        groupValue: _selected_class_start_afternoon,
                        onChanged: (int? value) {
                          setState(() {
                            _selected_class_start_afternoon = value!;
                          });
                        },
                        activeColor: Color(color_decide[user_color_decide][3]),
                      ),
                      Text(
                        '$print_class_start',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 10,),
            Visibility(
                visible: _selected_class_type==2?false:true,
                child: Text(
                    "堂數",
                  style: TextStyle(
                    color:Color(color_decide[user_color_decide][3]),
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
            ),
            Visibility(
              visible: _selected_class_type==2?false:true,
              child: Row(
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
                      activeColor: Color(color_decide[user_color_decide][3]),
                    ),
                    Text(
                      '$class_duration',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              }),
            ),
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
                    color: Color(color_decide[user_color_decide][3]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
      )
    );
  }
}
