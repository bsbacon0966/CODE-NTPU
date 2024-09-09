import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:interviewer/question.dart';
import 'package:interviewer/links.dart';

import '../GPA/GPA_calculator.dart';
import '../event_notify.dart';
import '../food_for_not_waste/food_for_not_waste.dart';
import '../food_for_not_waste/food_for_not_waste_main_page.dart';
import '../love_to_rain.dart';

List<bool> pinned = [false, false, false, false, false];

class the_total_page_2 extends StatefulWidget {
  @override
  _the_total_page_2 createState() => _the_total_page_2();
}

class _the_total_page_2 extends State<the_total_page_2> {
  List<int> containerOrder = [0, 1, 2, 3, 4, 5];
  bool isLoading = true;

  Future<void> loadUserData() async {
    await loadUserFavoriteService();
    setState(() {
      isLoading = false;
      _swapContainers();
    });
  }

  void initState() {
    super.initState();
    loadUserData();
  }
  void _swapContainers() {
    setState(() {
      List<int> tmp = List.filled(containerOrder.length, 0);
      int count_finished = 0;
      for (int i = 0; i < containerOrder.length; i++) {
        if (pinned[i]) {
          tmp[count_finished] = i;
          count_finished++;
        }
      }
      for (int i = 0; i < containerOrder.length; i++) {
        if (!pinned[i]) {
          tmp[count_finished] = i;
          count_finished++;
        }
      }
      for (int i = 0; i < containerOrder.length; i++) {
        containerOrder[i] = tmp[i];
      }
    });
  }

  Widget _build_main_service_page() {
    List<Widget> containers = [
      _buildContainer(0, Colors.lightGreen[100], 'Courtesy umbrella', 'assets/test_back.png', love_to_rain()),
      _buildContainer(1, Colors.yellow[200], 'Links in NTPU', 'assets/ux.png', ScheduleAndLinks()),
      _buildContainer(2, Colors.blue[100], '問卷調查集合處', 'assets/list.png', Question()),
      _buildContainer(3, Colors.red[100], 'Cherish blessing', 'assets/bibimbap.png',  FoodForNotWasteMainPage()),
      _buildContainer(4, Colors.purple[100], 'Event promotion', 'assets/event.png', event_notify()),
      _buildContainer(5, Colors.purple[100], 'GPA calculator', 'assets/event.png', CsvUploader()),
    ];

    List<Widget> orderedContainers = [];
    for (int index in containerOrder) {
      orderedContainers.add(
        Padding(
          padding: EdgeInsets.all(6.0),
          child: containers[index],
        ),
      );
    }
    return Column(children: orderedContainers);
  }

  Widget _buildContainer(int id, Color? color, String text, String imagePath, Widget path) {
    return FractionallySizedBox(
      widthFactor: 0.92,
      child: GestureDetector(
        onTap: () {
          Get.to(() => path, transition: Transition.rightToLeft);
        },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: color,
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
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    pinned[id] = !pinned[id];
                    updateUserFavoriteService();
                    _swapContainers();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: color,
                  minimumSize: Size(50, 50),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  pinned[id] ? Icons.favorite : Icons.favorite_border,
                  color: pinned[id] ? Colors.red : Colors.black45,
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
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  _build_main_service_page(),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

