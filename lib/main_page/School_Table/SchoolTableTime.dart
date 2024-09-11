import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../color_decide.dart';
import '../../firebase_store/fire_store_for_loading_personal_data.dart';
import 'SchoolTableTimeAddTasks.dart';
import 'SchoolTableTimeAdjustTasks.dart';

//["課程",1,9,0,3, "WEEKLY", 1, "MO", "多媒體技術", "資B104",2], //tag,semester,start_time_hours,start_time_minutes,duration_hours,frequency,以(日/周)當作循環,byDays,class_name,class_location
//["通識",1,14,0,3, "WEEKLY", 1, "TU", "線性代數", "電104"],
//["課程",1,9,0,1, "WEEKLY", 1, "WE", "進階資料結構", "資B104"],
List<List<dynamic>> personal_schedule_info = [];

class Schooltabletime extends StatefulWidget {
  @override
  State<Schooltabletime> createState() => _SchooltabletimeState();
}

class _SchooltabletimeState extends State<Schooltabletime> {
  bool isLoading = true;

  void initState() {
    super.initState();
    loadUserData();
  }
  Future<void> loadUserData() async {
    await loadUserPersonalSchedule();
    setState(() {
      isLoading = false;
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
            info[9],
            info[10],
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
                      color: Color(color_decide[user_color_decide][3]),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  view: CalendarView.workWeek,
                  firstDayOfWeek: 1,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 8,
                    endHour: 23,
                    timeIntervalHeight: 60,
                  ),
                  dataSource: ScheduleDataSource(getAppointmentsFromScheduleInfo()),
                  appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
                    final Appointment appointment = details.appointments.first;
                    return Container(
                      decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1,
                            offset: Offset(1.5, 1.5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.subject,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
          Positioned(
              top: 6.0,
              right: 16.0,
              child: SizedBox(
                width: 100.0,
                height: 40.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Get.to(Schooltabletimedeletetasks(),transition:Transition.rightToLeft);
                  },
                  child: Text(
                    "Adjust",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                  backgroundColor: Color(color_decide[user_color_decide][2]),
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
    int start_hours,
    int start_minute,
    int duration_hours,
    String frequency,
    int interval,
    String byDays,
    String class_info,
    String class_location,
    int class_duration,
    ) {
  List<Appointment> appointments = [];
  if(semester==1){
    final DateTime semester_startRange = DateTime(2024, 9, 9);
    final DateTime semester_endRange = DateTime(2024, 12, 29);
    if(tag == "課程"){
      final DateTime startTime;
      final DateTime endTime;
      if(class_duration==10){
        startTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          18,
          30,
        );
        endTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          21,
          10,
        );
      }
      else{
        startTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          start_hours,
          start_minute,
        );
        endTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          start_hours+duration_hours,
          start_minute,
        );
      }
      appointments.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: "$class_info\n\n$class_location",
          color: Color(color_decide[user_color_decide][3]),
          recurrenceRule: 'FREQ=$frequency;INTERVAL=$interval;BYDAY=$byDays;UNTIL=${semester_endRange.toUtc().toIso8601String()}',
        ),
      );
    }
    else if(tag == "通識"){
      final DateTime startTime;
      final DateTime endTime;
      if(class_duration==10){
        startTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          18,
          30,
        );
        endTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          21,
          10,
        );
      }
      else{
        startTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          start_hours,
          start_minute,
        );
        endTime = DateTime(
          semester_startRange.year,
          semester_startRange.month,
          semester_startRange.day,
          start_hours+duration_hours,
          start_minute,
        );
      }
      appointments.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: "$class_info\n\n$class_location",
          color: Color(color_decide[user_color_decide][2]),
          recurrenceRule: 'FREQ=$frequency;INTERVAL=$interval;BYDAY=$byDays;UNTIL=${semester_endRange.toUtc().toIso8601String()}',
        ),
      );
    }
  }
  return appointments;
}

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<Appointment> source) {
    appointments = source;
  }
}
