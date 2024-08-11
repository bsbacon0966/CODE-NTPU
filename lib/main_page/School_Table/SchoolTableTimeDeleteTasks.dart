import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';

import '../../main_page_and_menu/main_page_and_menu_initial.dart';
import 'SchoolTableTime.dart';

List<List<dynamic>> personal_schedule_info_delete = [];
class Schooltabletimedeletetasks extends StatefulWidget {
  @override
  State<Schooltabletimedeletetasks> createState() => _SchooltabletimedeletetasksState();
}

class _SchooltabletimedeletetasksState extends State<Schooltabletimedeletetasks> {
  bool isLoading = true;
  Map<String, String> dayToString = {
    "MO": "(一)",
    "TU": "(二)",
    "WE": "(三)",
    "THU": "(四)",
    "FRI": "(五)",
  };
  Future<void> loadUserData() async {
    await loadUserPersonalScheduleDelete();
    setState(() {
      isLoading = false;
    });
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
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(3, 3),
              ),
            ],
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
                                fontSize: 20.0,
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
                                    fontSize: 20.0,
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
                                    fontSize: 20.0,
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


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DELETE YOUR TASKS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Warning'),
                      content: Text('刪除的資訊將永久刪除，是否確定刪除?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await updateUserPersonalScheduleDelete();
                            Get.to(TheBigTotalPage(selectedIndex: 2));
                          },
                          child: Text('確認'),
                        )
                      ],
                    ),
                  );
                  /*await updateUserPersonalScheduleDelete();
                  Get.to(TheBigTotalPage(selectedIndex: 2));*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "確定刪除結果",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: personal_schedule_info_delete.length,
              itemBuilder: (context, index) {
                return _buildContainer(
                    personal_schedule_info_delete[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}