import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:interviewer/question.dart';
import 'package:interviewer/links.dart';
import 'package:interviewer/talk_for_test/taik.dart';

import '../GPA/GPA_calculator.dart';
import '../event_notify.dart';
import '../food_for_not_waste/food_for_not_waste.dart';
import '../food_for_not_waste/food_for_not_waste_main_page.dart';
import '../love_to_rain.dart';
import 'dart:ui';

import '../map_for_eating/map_for_eating.dart';
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
      _buildContainer(0, Colors.lightGreen[100], '愛心傘租借/歸還', 'assets/warning.png', love_to_rain()),
      _buildContainer(1, Colors.yellow[200], '北大連結集中區', 'assets/link_block_3.png', ScheduleAndLinks()),
      _buildContainer(2, Colors.blue[100], '問卷調查集合處', 'assets/text_block_2.png', FortuneWheelDemo()),
      _buildContainer(3, Colors.red[100], '惜福專區', 'assets/bibimbap.png',  FoodForNotWasteMainPage()),
      _buildContainer(4, Colors.purple[100], '活動宣傳', 'assets/warning.png', event_notify()),
      _buildContainer(5, Colors.purple[100], '測試者聊天室', 'assets/chat_block_5.png', TalkToMe()), //測試服，之後是CSVloader
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
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(5, 5),
              ),
            ],
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              // Blurred background image
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                    // Blur effect applied to the image
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              // Centered content above the blurred image
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text styling
                      Expanded(
                        child: Text(
                          text,
                          textAlign: TextAlign.center, // Center text horizontally
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Improved button styling
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            pinned[id] = !pinned[id];
                            updateUserFavoriteService();
                            _swapContainers();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          backgroundColor: Colors.white.withOpacity(0.8),
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

