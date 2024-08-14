import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:quickalert/quickalert.dart';
import '../../main_page_and_menu/main_page_and_menu_initial.dart';
import 'SchoolTableTime.dart';
import 'SchoolTableTimeAddTasks.dart';

List<List<dynamic>> personal_schedule_info_delete = [];
class Schooltabletimedeletetasks extends StatefulWidget {
  @override
  State<Schooltabletimedeletetasks> createState() => _SchooltabletimedeletetasksState();
}

class _SchooltabletimedeletetasksState extends State<Schooltabletimedeletetasks> {
  bool isLoading = true;
  void list_sort(){
    for(int i=0;i<personal_schedule_info_delete.length;i++){
      for(int j=i+1;j<personal_schedule_info_delete.length;j++){
        if(dayToInt[personal_schedule_info_delete[i][7]]! > dayToInt[personal_schedule_info_delete[j][7]]!){
          dynamic tmp = personal_schedule_info_delete[i];
          personal_schedule_info_delete[i] = personal_schedule_info_delete[j];
          personal_schedule_info_delete[j] = tmp;
        }
      }
    }
    for(int i=0;i<personal_schedule_info_delete.length;i++){
      for(int j=i+1;j<personal_schedule_info_delete.length;j++){
        if(dayToInt[personal_schedule_info_delete[i][7]]==dayToInt[personal_schedule_info_delete[j][7]]&&personal_schedule_info_delete[i][10]>personal_schedule_info_delete[j][10]){
          dynamic tmp = personal_schedule_info_delete[i];
          personal_schedule_info_delete[i] = personal_schedule_info_delete[j];
          personal_schedule_info_delete[j] = tmp;
        }
      }
    }
  }
  Map<String, String> dayToString = {
    "MO": "(一)",
    "TU": "(二)",
    "WE": "(三)",
    "THU": "(四)",
    "FRI": "(五)",
  };
  Map<String, int> dayToInt = {
    "MO": 1,
    "TU": 2,
    "WE": 3,
    "THU": 4,
    "FRI": 5,
  };
  Future<void> loadUserData() async {
    await loadUserPersonalScheduleDelete();
    list_sort();
    setState(() {
      isLoading = false;
    });
  }
  void _updatePersonalScheduleInfo(List<dynamic> newTasks) {
    setState(() {
      personal_schedule_info_delete.add(newTasks);
    });
    list_sort();
  }
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> _removeTask(int index) async {
    personal_schedule_info_delete.removeAt(index);
    setState(() {});
  }

  Widget _buildContainer(List<dynamic> task, int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FractionallySizedBox(
        widthFactor: 0.92,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: Color(color_decide[user_color_decide][2]),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 1,
                offset: Offset(5, 5),
              ),
            ],
            border: Border.all(
              color: Colors.black, // 黑色外框
              width: 2.0, // 外框宽度，可根据需要调整
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: Text(
                            task[8],
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                dayToString[task[7]]!,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              child: Text(
                                task[10]==10 ? "晚上":"${task[10]} - ${task[4] + task[10] - 1} 堂",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _removeTask(index);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(color_decide[user_color_decide][2]),
                  backgroundColor: Colors.white,
                  minimumSize: Size(50, 50),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  Icons.delete,
                  color: Color(color_decide[user_color_decide][3]),
                ),
              ),
            ],
          ),
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Theme(
      data: dynamicTheme,
      child:
      Scaffold(
        appBar: AppBar(
          title: Text(
            'ADJUST YOUR TASKS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Color(color_decide[user_color_decide][3]),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        offset: Offset(5, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black, // 黑色外框
                      width: 2.0, // 外框宽度，可根据需要调整
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Schooltabletimeaddtasks(
                            onSubmit: _updatePersonalScheduleInfo,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(color_decide[user_color_decide][3]),
                    ),
                    child: Text(
                      "新增課程",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        offset: Offset(5, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black, // 黑色外框
                      width: 2.0, // 外框宽度，可根据需要调整
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: '資訊將上傳，是否確定?',
                        text: '確定前，上述操作皆不會被記錄',
                        confirmBtnText: '確認',
                        cancelBtnText: '取消',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () async {
                          await updateUserPersonalScheduleDelete();
                          Get.to(TheBigTotalPage(selectedIndex: 2));
                        },
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "確定結果",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: personal_schedule_info_delete.length,
                itemBuilder: (context, index) {
                  return _buildContainer(
                      personal_schedule_info_delete[index], index
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}