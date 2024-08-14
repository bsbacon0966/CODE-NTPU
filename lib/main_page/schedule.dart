import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/question.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart'; // 確保導入 scroll_snap_list 包
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../event_notify.dart';
import '../food_for_not_waste.dart';
import '../links.dart';
import '../love_to_rain.dart';

class ScheduleInMain extends StatefulWidget {
  const ScheduleInMain({super.key});

  @override
  State<ScheduleInMain> createState() => _ScheduleInMainState();
}

class _ScheduleInMainState extends State<ScheduleInMain> {
  int _currentIndex = 1;
  bool is_newborn = false;
  List<List<String>> month_8 = [
    ["1-7","本學期第1次選課","NO"],
    ["1-10","學士班、進修學士班輔系、雙主修線上申請","NO"],
    ["20-22","三峽校區線上申請宿舍","NO"],
    ["20-26","本學期第2次選課(含新生)","NO"],
    ["20-31","學士班新生入學線上報到","YES"],
  ];
  List<List<String>> month_9 = [
    ["1-2","三峽校區宿生入住","NO"],
    ["1-5","學士班新生入學線上報到","YES"],
    ["4","註冊繳費截止日","NO"],
    ["4","新生持校外英檢成績線上抵免或免修大學英文截止","YES"],
    ["4-5","學士班(含轉校生)新生導航","YES"],
    ["8","新生健康檢查日","YES"],
    ["10-19","113-1加退選、抵免學分受理申請","NO"],
    ["16","112-2教授補送成績截止日","NO"],
    ["17","中秋節放假一天","NO"],
    ["20-30","人工加簽開始受理","NO"],
    ["24-30","線上選課確認","NO"],
    ["25","補註冊日","NO"],
  ];
  List<List<String>> month_10 = [
    ["10","國慶日放假一天","NO"],
    ["19","運動會與本校校慶活動","NO"],
    ["28-31","學士班期中考試","NO"],
  ];
  List<List<String>> month_11 = [
    ["1","學士班期中考試","NO"],
    ["4-15","申請棄修課程","NO"],
    ["4-17","加退選學分費繳費","NO"],
    ["30","放棄雙主修、輔系截止日","NO"],
    ["30","學士班、進修學士班提前畢業申請截止日","NO"],
    ["30","完成學士班、進修學士班畢業資格初審","NO"],
  ];
  List<List<String>> month_12 = [
    ["10","完成學士班、進修學士班畢業資格複審","NO"],
    ["20","學士班、進修學士班申請本學期休學截止日","NO"],
    ["23-27","學士班期末考試","NO"],
    ["30","寒假開始","NO"],
    ["23-27","113-2第1次選課","NO"],
  ];
  List<List<String>> month_1 = [
    ["1","開國紀念日放假一天","NO"],
    ["7","4年級班任課教師繳送113學年度第1學期成績截止日","NO"],
    ["14","學士班任課教師繳送113學年度第1學期成績截止日","NO"],
    ["14-20","113-2第2次選課","NO"],
  ];


  Widget _build_main_service_page(int Index) {
    List<Widget> containers = [];
    if(Index==0){
      for(int i=0;i<month_8.length;i++){
        if(is_newborn&&month_8[i][2]=="YES") containers.add(_buildContainer(month_8[i][0], month_8[i][1]));
        else containers.add(_buildContainer(month_8[i][0], month_8[i][1]));
      }
    }
    else if(Index==1){
      for(int i=0;i<month_9.length;i++){
        if(month_9[i][2]=="YES") {
          if(is_newborn) containers.add(_buildContainer(month_9[i][0], month_9[i][1]));
        }
        else containers.add(_buildContainer(month_9[i][0], month_9[i][1]));
      }
    }
    else if(Index==2){
      for(int i=0;i<month_10.length;i++){
        if(is_newborn&&month_10[i][2]=="YES") containers.add(_buildContainer(month_10[i][0], month_10[i][1]));
        else containers.add(_buildContainer(month_10[i][0], month_10[i][1]));
      }
    }
    else if(Index==3){
      for(int i=0;i<month_11.length;i++){
        if(month_11[i][2]=="YES") {
          if(is_newborn) containers.add(_buildContainer(month_11[i][0], month_11[i][1]));
        }
        else containers.add(_buildContainer(month_11[i][0], month_11[i][1]));
      }
    }
    else if(Index==4){
      for(int i=0;i<month_12.length;i++){
        if(is_newborn&&month_12[i][2]=="YES") containers.add(_buildContainer(month_12[i][0], month_12[i][1]));
        else containers.add(_buildContainer(month_12[i][0], month_12[i][1]));
      }
    }
    else if(Index==5){
      for(int i=0;i<month_1.length;i++){
        if(is_newborn&&month_1[i][2]=="YES") containers.add(_buildContainer(month_1[i][0], month_1[i][1]));
        else containers.add(_buildContainer(month_1[i][0], month_1[i][1]));
      }
    }
    List<Widget> orderedContainers = [];
    return Column(children: containers);
  }

  Widget _buildContainer(String day, String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: BoxDecoration(
            color: Color(color_decide[user_color_decide][1]),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 1,
                offset: Offset(4, 4),
              ),
            ],
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
  final Map<int, String> _month = {
    0: "8",
    1: "9",
    2: "10",
    3: "11",
    4: "12",
    5: "1",
  };
  Widget month_selete(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.28,
      child: Center(
        child:Row(
          children: [
            Icon(
              Icons.chevron_left,
              color: Color(color_decide[user_color_decide][2]),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ScrollSnapList(
                itemBuilder: (context, index) {
                  bool isFocused = index == _currentIndex;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.25, // Width of each item
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _month[index]! + "月",
                          style: TextStyle(
                            fontSize: isFocused ? 40 : 25,
                            color: Color(color_decide[user_color_decide][2]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: 6,
                itemSize: MediaQuery.of(context).size.width * 0.25, // Size of each item
                onItemFocus: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                initialIndex: 1,
                dynamicItemSize: true,
              ),
            ),
            Icon(
                Icons.chevron_right,
                color:Color(color_decide[user_color_decide][2])
            ),
          ],
        )

      ),
    );
  }
  final Map<int, Widget> _imageMap = {
    0: Image.asset("assets/month/8.jpg"),
    1: Image.asset("assets/month/9.jpg"),
    2: Image.asset("assets/month/10.jpg"),
    3: Image.asset("assets/month/11.jpg"),
    4: Image.asset("assets/month/12.jpg"),
    5: Image.asset("assets/month/1.jpg"),
  };
  Widget month_news(int _currentIndex) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.4,
      child: _imageMap[_currentIndex] ?? SizedBox.shrink(),
    );
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
      body: ListView(
        children: [
          Container(
            child: month_selete(context),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.35,
            child: month_news(_currentIndex),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                        "新生",
                      style: TextStyle(
                        fontWeight:FontWeight.w600,
                        fontSize: 25,
                          color:Color(color_decide[user_color_decide][2]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Container(
                        width: 50,
                        child: Switch(
                          value: is_newborn,
                          activeColor: Color(color_decide[user_color_decide][2]),
                          onChanged: (bool value) {
                            setState(() {
                              is_newborn = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          _build_main_service_page(_currentIndex),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}