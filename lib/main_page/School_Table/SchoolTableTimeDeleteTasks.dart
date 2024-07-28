import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
            color: Color(0xff95b0ce),
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
                                "${task[10]} - ${task[4] + task[10] - 1} 堂",
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
                  foregroundColor: Color(0xff538cc5),
                  backgroundColor: Colors.white,
                  minimumSize: Size(50, 50),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  Icons.delete,
                  color: Color(0xff739abe),
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
          ElevatedButton(
            onPressed: () async {
              await updateUserPersonalScheduleDelete();
              Get.to(TheBigTotalPage(selectedIndex: 2));
            },
            child: Text("確定刪除結果"),
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