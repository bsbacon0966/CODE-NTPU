//嗨嗨李彥廷，我寫的很亂，有空再跟你說我怎麼用的

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:interviewer/food_for_not_waste.dart';
import 'package:interviewer/question.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:interviewer/view_the_map.dart';
import 'package:interviewer/Personal_Menu.dart';
import 'package:interviewer/schedule_and_links.dart';
import 'package:interviewer/love_to_rain.dart';
import 'package:interviewer/event_notify.dart';
import 'package:interviewer/food_for_not_waste.dart';
import 'package:interviewer/question.dart';

final Uri _lms = Uri.parse('https://lms3.ntpu.edu.tw/login/index.php');
final Uri _SIS = Uri.parse('https://cof.ntpu.edu.tw/student_new.htm');
final Uri _leave = Uri.parse('https://cof.ntpu.edu.tw/pls/acad2/leave_sys.home');
final Uri _event = Uri.parse('https://cof.ntpu.edu.tw/pls/eval/REG_2ORDER_M2.event_list');
final Uri _csd = Uri.parse('https://csd.ntpu.edu.tw/');
final Uri _no21 = Uri.parse('https://no21.ntpu.org/');
final Uri _oaa = Uri.parse('https://new.ntpu.edu.tw/oaa/files?inline=1&tag=%E8%A1%8C%E4%BA%8B%E6%9B%86&descent=true');

final Uri _CL = Uri.parse('https://www.cl.ntpu.edu.tw/');
final Uri _DAFL = Uri.parse('https://www.dafl.ntpu.edu.tw/');
final Uri _HIS = Uri.parse('https://history.ntpu.edu.tw/');

final Uri _ECON = Uri.parse('https://econ.ntpu.edu.tw/');
final Uri _SOC = Uri.parse('https://sociology.ntpu.edu.tw/index.php/ch');
final Uri _SW = Uri.parse('https://www.sw.ntpu.edu.tw/');

final Uri _PA = Uri.parse('https://pa.ntpu.edu.tw/zh-tw');
final Uri _FINC = Uri.parse('https://finc.ntpu.edu.tw/');
final Uri _REBE = Uri.parse('http://www.rebe.ntpu.edu.tw/');

final Uri _EE = Uri.parse('https://ee.ntpu.edu.tw/');
final Uri _CS = Uri.parse('https://www.csie.ntpu.edu.tw/');
final Uri _CE = Uri.parse('https://www.ce.ntpu.edu.tw/');

final Uri _LAW = Uri.parse('https://www.ce.ntpu.edu.tw/');

final Uri _ACC = Uri.parse('https://www.acc.ntpu.edu.tw/');
final Uri _DBA = Uri.parse('https://www.dba.ntpu.edu.tw/');
final Uri _COOP = Uri.parse('https://coop.ntpu.edu.tw/');
final Uri _STAT = Uri.parse('https://www.stat.ntpu.edu.tw/');
final Uri _LSM = Uri.parse('https://lsm.ntpu.edu.tw/');

final Uri _LIB = Uri.parse('https://library.ntpu.edu.tw/masses/showMassesLogin;jsessionid=CC9DAA0BAF53597BF8B5A3B578E55512');
final Uri _READ = Uri.parse('https://ireserve.lib.ntpu.edu.tw/sm/home_web.do?locale=zh_TW');

//------slide menu跟主要畫面合併----------------------------------------------
class TheBigTotalPage extends StatefulWidget {
  @override
  _TheBigTotalPageState createState() => _TheBigTotalPageState();
}

class _TheBigTotalPageState extends State<TheBigTotalPage> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        showShadow: true,
        menuBackgroundColor: Colors.indigo,
        menuScreen: MenuPage(),
        mainScreen: the_total_page(),
        angle: 0,
    );
  }
}
//------menu跟主要畫面合併------------------------------------------------------------------------------------


class the_total_page extends StatefulWidget {
  @override
  _the_total_page createState() => _the_total_page();
}

class _the_total_page extends State<the_total_page> {

  //------初始化變數--------------------------------------------------------------------------------------------
  int count = 0;
  List<int> containerOrder = [0, 1, 2, 3,4];
  List<bool> pinned = [false, false, false, false, false];
  List<bool> hyper_link_is_on = [true,true,true,true,false,false,false,false,false,false];
  //------初始化變數--------------------------------------------------------------------------------------------

  //------主要畫面(到文字"服務項目")建構-----------------------------------------------------------------------
  Widget _main_info() {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Container(
                        width: 25,
                        child: Image.asset(
                          "assets/board.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "佈告欄",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.92,
          child: SizedBox(
            height: 200.0,
            width: 500.0,
            child: AnotherCarousel(
              images: [
                AssetImage("assets/ntpu.png"),
                AssetImage("assets/ntpu.png"),
              ],
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: Colors.lightGreenAccent,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.purple.withOpacity(0.1),
              borderRadius: true,
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Container(
                        width: 28,
                        child: Image.asset(
                          "assets/link-building.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "個人快速連結",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _build_hyper_link_list_in_main_page(),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Container(
                        width: 28,
                        child: Image.asset(
                          "assets/public-service.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "服務項目",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  //------主要畫面(到文字"服務項目")建構------------------------------------------------------------------------------------------

  //------建構服務項目專區------------------------------------------------------------------------------------------------------
  void _swapContainers() { //-----服務專區之計算位置方式----------------
    setState(() {
      List<int> tmp = List.filled(containerOrder.length,0);
      int count_finished = 0;
      for(int i=0;i<containerOrder.length;i++){
        if(pinned[i]){
          tmp[count_finished] = i;
          count_finished++;
        }
      }
      for(int i=0;i<containerOrder.length;i++){
        if(!pinned[i]){
          tmp[count_finished] = i;
          count_finished++;
        }
      }
      for(int i=0;i<containerOrder.length;i++){
        containerOrder[i] = tmp[i];
      }
    });
  }//-----服務專區之計算位置方式----------------------------------

  Widget _build_main_service_page() {
    List<Widget> containers = [
      _buildContainer(0, Colors.lightGreen[100], '愛心傘借助/歸還', 'assets/test_back.png', love_to_rain()),
      _buildContainer(1, Colors.yellow[200], '北大常用連結', 'assets/ux.png', ScheduleAndLinks()),
      _buildContainer(2, Colors.blue[100], '問卷調查集合處', 'assets/list.png', Question()),
      _buildContainer(3, Colors.red[100], '愛心食品', 'assets/bibimbap.png', food_for_not_waste()),
      _buildContainer(4, Colors.purple[100], '活動宣傳', 'assets/event.png', event_notify()),
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

  //------建構服務項目專區----------------------------------------------------------------

  //-----個人快速連結專區------------------------------------------------------------------------------------
  List<Widget> _build_hyper_link_list_in_main_page(){
    List<Widget> orderedContainers = [];
    if(hyper_link_is_on[0]) {
      orderedContainers.add(hyper_link_in_main_page(context, "北大3.0", "assets/test_back.png", _lms));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[1]){
      orderedContainers.add(hyper_link_in_main_page(context, "學生資訊", "assets/test_back.png", _SIS));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[2]){
      orderedContainers.add(hyper_link_department_in_main_page(context, "各系網站", "assets/test_back.png",));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[3]) {
      orderedContainers.add(hyper_link_in_main_page(context, "學校講座", "assets/test_back.png", _event));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[4]){
      orderedContainers.add(hyper_link_in_main_page(context, "請假", "assets/test_back.png", _leave));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[5]){
      orderedContainers.add(hyper_link_in_main_page(context, "軟體授權", "assets/test_back.png", _csd));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[6]){
      orderedContainers.add(hyper_link_in_main_page(context, "選課大全", "assets/test_back.png", _no21));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[7]){
      orderedContainers.add(hyper_link_in_main_page(context, "行事曆", "assets/test_back.png", _oaa));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[8]){
      orderedContainers.add(hyper_link_in_main_page(context, "圖書館", "assets/test_back.png", _LIB));
      orderedContainers.add(SizedBox(width: 10));
    }
    if(hyper_link_is_on[9]){
      orderedContainers.add(hyper_link_in_main_page(context, "座位預約", "assets/test_back.png", _READ));
      orderedContainers.add(SizedBox(width: 10));
    }
    orderedContainers.add(Padding(
      padding: EdgeInsets.all(10.0),
      child:hyper_link_wanted_in_main_page(context,"assets/test_back.png")),
    );
    return orderedContainers;
  }
  Widget _buildContainer(int id, Color? color, String text, String imagePath,Widget path) {
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
                  pinned[id]? Icons.favorite: Icons.favorite_border ,
                  color: pinned[id]? Colors.red : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget hyper_link_in_main_page(BuildContext context, String info, String info_picture, Uri link){ //一般的快速連結
    return GestureDetector(
      onTap: () => _launchUrl(link),
      child:SizedBox(
        width: MediaQuery.of(context).size.width * 0.30,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(3.0),
                width: 50,
                height: 50,
                child: Image.asset(info_picture),
              ),
              Text(
                info,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget hyper_link_department_in_main_page(BuildContext context, String info,String info_picture){ //為了"各系網站"所加的dialog
    return GestureDetector(
      onTap:(){
        _show_department_Dialog(context);
      },
      child:SizedBox(
        width: MediaQuery.of(context).size.width * 0.30,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.red[100],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.all(3.0),
                  width: 50,
                  height: 50,
                  child: Image.asset(info_picture),
                ),
                Text(
                  info,
                  style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
            )
          ],
        ),
      ),
      )
    );
  }

  Widget hyper_link_wanted_in_main_page(BuildContext context, String info_picture){ //後面點選後會跳dialog的格子
    return GestureDetector(
      onTap:(){
        _showDialog(context);
      },
      child:SizedBox(
        width: MediaQuery.of(context).size.width * 0.30,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(3.0),
                width: 50,
                height: 50,
                child: Icon(
                  Icons.add,
                  color: Colors.blue[100],
                  size:40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //給個人快速連結update的處理法
  void updateMainScreen(List<bool> newHyperLinkIsOn) {//------不知道為何有了這句就跑得動了???????----------
    setState(() {
      hyper_link_is_on = List.from(newHyperLinkIsOn);
    });
  }
  void _showDialog(BuildContext context) { // 給新增個人連結項目的dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<bool> localHyperLinkIsOn = List.from(hyper_link_is_on);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '勾選新增/刪除的項目',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("數位學院3.0"),
                      Checkbox(
                        value: localHyperLinkIsOn[0],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[0] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("學生資訊系統"),
                      Checkbox(
                        value: localHyperLinkIsOn[1],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[1] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("各系網站"),
                      Checkbox(
                        value: localHyperLinkIsOn[2],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[2] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("學生講座系統"),
                      Checkbox(
                        value: localHyperLinkIsOn[3],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[3] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("學生請假系統"),
                      Checkbox(
                        value: localHyperLinkIsOn[4],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[4] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("北大軟體授權"),
                      Checkbox(
                        value: localHyperLinkIsOn[5],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[5] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("選課大全"),
                      Checkbox(
                        value: localHyperLinkIsOn[6],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[6] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("北大行事曆"),
                      Checkbox(
                        value: localHyperLinkIsOn[7],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[7] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("圖書館登入"),
                      Checkbox(
                        value: localHyperLinkIsOn[8],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[8] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hyper_list_dialog_info("圖書館座位預約"),
                      Checkbox(
                        value: localHyperLinkIsOn[9],
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            localHyperLinkIsOn[9] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    updateMainScreen(localHyperLinkIsOn);
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //處理"各系網站"的dialog
  Widget department(BuildContext context,String name,Uri link){//"各系網站"所加的dialog part 1 統一規格
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.065;
    return Padding(
      padding: EdgeInsets.all(7.0),
      child:SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.12,
          child: ElevatedButton(
            onPressed:()=> _launchUrl(link),
            child: Text(
              name,
              style:TextStyle(
                fontSize: textSize,
              ),
            ),
          )
      ),
    );
  }
  Widget class_info(String name,VoidCallback path){//"各系網站"所加的dialog中part 2每個學系的統一規格
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.07;
    if(name.length==4) textSize = screenWidth * 0.045;
    return SizedBox(
      width:MediaQuery.of(context).size.width * 0.32,
      height: 70,
      child:ElevatedButton(
        onPressed: path,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
  void _show_department_Dialog(context){//"各系網站"所加的dialog part 1
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('選擇學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      class_info("人文", () {
                        Navigator.of(context).pop();
                        _show_Humanities_Dialog(context);
                      }),
                      SizedBox(width: 10),
                      class_info("社會科學", () {
                        Navigator.of(context).pop();
                        _show_Social_Dialog(context);
                      }),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                      children: [
                        class_info("商學", () {
                          Navigator.of(context).pop();
                          _show_Bussiness_Dialog(context);
                        }),
                        SizedBox(width: 10),
                        class_info("公共事務", () {
                          Navigator.of(context).pop();
                          _show_Public_Dialog(context);
                        }),
                      ]
                  ),
                  SizedBox(height: 15),
                  Row(
                      children: [
                        SizedBox(
                          width:MediaQuery.of(context).size.width * 0.32,
                          height: 70,
                          child:ElevatedButton(
                            onPressed: ()=> _launchUrl(_LAW),
                            child: Text(
                              "法律",
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        class_info("電機資訊", () {
                          Navigator.of(context).pop();
                          _show_Computer_Dialog(context);
                        }),
                      ]
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _show_Humanities_Dialog(BuildContext context) {//"各系網站"所加的dialog part 2
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('人文學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(context,"中國文學系",_CL),
                  department(context,"應用外語學系",_DAFL),
                  department(context,"歷史學系",_HIS),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _show_Bussiness_Dialog(BuildContext context) {//"各系網站"所加的dialog part 2
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('商學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(context,"會計學系",_ACC),
                  department(context,"企業管理學系",_DBA),
                  department(context,"金融與合作經營學系",_COOP),
                  department(context,"統計學系",_STAT),
                  department(context,"休閒運動管理學系",_LSM),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _show_Social_Dialog(BuildContext context) {//"各系網站"所加的dialog part 2
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('社會科學學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(context,"經濟學系",_ECON),
                  department(context,"社會學系",_SOC),
                  department(context,"社會工作系",_SW),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _show_Public_Dialog(BuildContext context) {//"各系網站"所加的dialog part 2
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('公共事務學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(context,"公共行政暨政策學系",_PA),
                  department(context,"財政學系",_FINC),
                  department(context,"不動產與城鄉環境學系",_REBE),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _show_Computer_Dialog(BuildContext context) {//"各系網站"所加的dialog part 2
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('電機資訊學院'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(context,"電機工程學系",_EE),
                  department(context,"資訊工程學系",_CS),
                  department(context,"通訊工程學系",_CE),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget hyper_list_dialog_info(String name){
    return Text(
      name,
      style: TextStyle(
        fontSize: 22,
      ),
    );
  }
  //-----個人快速連結專區------------------------------------------------------------------------------------

  //------主要畫面合併-------------------------------------------------------------------
  List<Widget> _build_main_page() {
    List<Widget> orderedContainers = [];
    orderedContainers.add(_main_info());
    orderedContainers.add(_build_main_service_page());
    return orderedContainers;
  }
  //------主要畫面合併--------------------------------------------------------------------------------------

  //----整體建構(畫面與appbar等功能結合)------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'CODE_NTPU',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: (){
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
                children: _build_main_page(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//----整體建構(畫面與appbar等功能結合)-----------------------------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.blue,
          )
      ),
      debugShowCheckedModeBanner: false,
      home: TheBigTotalPage(),
    );
  }
}

Future<void> _launchUrl(Uri links) async {
  if (!await launchUrl(links)) {
    throw Exception('Could not launch $links');
  }
}
