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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.15,
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        task[7], // Use the correct index to get the task
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  )

                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _removeTask(index); // Call the async method
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
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