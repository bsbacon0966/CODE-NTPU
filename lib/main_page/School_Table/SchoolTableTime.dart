import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'SchoolTableTimeAddTasks.dart';

class Schooltabletime extends StatefulWidget {
  @override
  State<Schooltabletime> createState() => _SchooltabletimeState();
}

class _SchooltabletimeState extends State<Schooltabletime> {
  List<List<dynamic>> personal_schedule_info = [
    ["課程",1, 9, 12, "WEEKLY", 1, "MO", "多媒體技術", "資B104"],
    ["通識",1, 14, 17, "WEEKLY", 1, "TU", "線性代數", "電104"],
    ["課程",1, 9, 12, "WEEKLY", 1, "WE", "進階資料結構", "資B104"],
  ];

  void _updatePersonalScheduleInfo(List<dynamic> newTasks) {
    setState(() {
      personal_schedule_info.add(newTasks);
    });
  }

  List<Appointment> getAppointmentsFromScheduleInfo() {
    List<Appointment> appointments = [];
    for (var info in personal_schedule_info) {
      appointments.addAll(
          getAppointments(
            info[0],
            info[1],
            info[2],
            info[3],
            info[4],
            info[5],
            info[6],
            info[7],
            info[8],
          )
      );
    }
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CODE:NTPU',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: SfCalendar(
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      color: Color(0xff95b0ce), // Set the desired color
                      fontSize: 22, // Set the desired font size
                      fontWeight: FontWeight.bold, // Set the desired font weight
                    ),
                  ),
                  view: CalendarView.workWeek,
                  firstDayOfWeek: 1,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 8,
                    endHour: 23,
                  ),
                  dataSource: ScheduleDataSource(getAppointmentsFromScheduleInfo()),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
          Positioned(
              top: 6.0,
              right: 16.0,
              child: SizedBox(
                width: 100.0, // 設置寬度
                height: 40.0, // 設置高度
                child: FloatingActionButton(
                  onPressed: () {
                    final newTasks = Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Schooltabletimeaddtasks(
                          onSubmit: _updatePersonalScheduleInfo,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "ADD TASK",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ), // 設置圖標大小
                  backgroundColor: Color(0xff95b0ce), // 按鈕背景顏色
                ),
              )
          ),
        ],
      ),
    );
  }
}

List<Appointment> getAppointments(
    String tag,
    int semester,
    int start_time_hours,
    int end_time_hours,
    String frequency,
    int interval,
    String byDays,
    String class_name,
    String class_location
    ) {
  List<Appointment> appointments = [];
  if(tag == "課程"){
    final DateTime semester_startRange = DateTime(2024, 9, 9);
    final DateTime semester_endRange = DateTime(2024, 12, 29);
    final DateTime startTime = DateTime(
        semester_startRange.year,
        semester_startRange.month,
        semester_startRange.day,
        start_time_hours,
        0
    );
    final DateTime endTime = DateTime(
        semester_startRange.year,
        semester_startRange.month,
        semester_startRange.day,
        end_time_hours,
        0
    );
    appointments.add(
      Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: "$class_name\n$class_location",
        color: Color(0xff95b0ce),
        recurrenceRule: 'FREQ=$frequency;INTERVAL=$interval;BYDAY=$byDays;UNTIL=${semester_endRange.toUtc().toIso8601String()}',
      ),
    );
  }
  else if(tag == "通識"){
    final DateTime semester_startRange = DateTime(2024, 9, 9);
    final DateTime semester_endRange = DateTime(2024, 12, 29);
    final DateTime startTime = DateTime(
        semester_startRange.year,
        semester_startRange.month,
        semester_startRange.day,
        start_time_hours,
        0
    );
    final DateTime endTime = DateTime(
        semester_startRange.year,
        semester_startRange.month,
        semester_startRange.day,
        end_time_hours,
        0
    );
    appointments.add(
      Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: "$class_name\n$class_location",
        color: Color(0xffa1bade),
        recurrenceRule: 'FREQ=$frequency;INTERVAL=$interval;BYDAY=$byDays;UNTIL=${semester_endRange.toUtc().toIso8601String()}',
      ),
    );
  }
  return appointments;
}

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<Appointment> source) {
    appointments = source;
  }
}
