import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:interviewer/main_page/schedule.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:interviewer/view_the_map.dart';
import 'package:interviewer/personal_menu/Personal_Menu.dart';
import 'package:interviewer/links.dart';
import 'package:interviewer/love_to_rain.dart';
import 'package:interviewer/event_notify.dart';
import 'package:interviewer/food_for_not_waste.dart';
import 'package:interviewer/question.dart';
import 'package:interviewer/firebase_store/fire_store.dart';
import 'package:interviewer/main_page/main_second.dart';
import 'package:interviewer/main_page/School_Table/SchoolTableTime.dart';

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





List<bool> hyper_link_is_on = [true, true, true, true, false, false, false, false, false, false];



class the_total_page extends StatefulWidget {
  @override
  _the_total_page createState() => _the_total_page();
}

class _the_total_page extends State<the_total_page> {

  //------初始化變數--------------------------------------------------------------------------------------------
  int count = 0;
  final FirestoreServices FS = FirestoreServices();
  int currentPage = 0;


  //------初始化變數--------------------------------------------------------------------------------------------
  int _currentPage = 0;
  late Timer _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  //------主要畫面1建構-----------------------------------------------------------------------
  Widget _main_info() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width* 0.506,
          width: MediaQuery.of(context).size.width* 0.9,
          child: PageView(
              controller: _pageController,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // 设置圆角半径
                    child: Image.asset(
                      "assets/Logo.gif",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // 设置圆角半径
                    child: Image.asset(
                      "assets/ntpu.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]
          ),
        ),
        SizedBox(height: 5),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: ExpandingDotsEffect(),
        ),
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
          width: MediaQuery.of(context).size.width * 0.92,
          child: Column(
              children: [
                _build_hyper_link_list_in_main_page_with_three_in_one_row(
                    _build_hyper_link_list_in_main_page()
                ),
              ]
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  //------主要畫面(到快速連結)建構------------------------------------------------------------------------------------------

  Widget _build_hyper_link_list_in_main_page_with_three_in_one_row(List<Widget> orderedContainers) {
    List<Widget> rows = [];
    List<Widget> row = [];
    for (int i = 0; i < orderedContainers.length; i++) {
      row.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.0), // Adjust padding as needed
            child: orderedContainers[i],
          ),
        ),
      );
      if ((i + 1) % 3 == 0 || i == orderedContainers.length - 1) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: row,
          ),
        );
        row = [];
      }
    }
    return Column(
      children: rows,
    );
  }
  //-----個人快速連結專區------------------------------------------------------------------------------------
  List<Widget> _build_hyper_link_list_in_main_page() {
    List<Widget> orderedContainers = [];
    if (hyper_link_is_on[0]) {
      orderedContainers.add(hyper_link_in_main_page(context, "北大3.0", "assets/test_back.png", _lms));
    }
    if (hyper_link_is_on[1]) {
      orderedContainers.add(hyper_link_in_main_page(context, "學生資訊", "assets/test_back.png", _SIS));
    }
    if (hyper_link_is_on[2]) {
      orderedContainers.add(hyper_link_department_in_main_page(context, "各系網站", "assets/test_back.png",));
    }
    if (hyper_link_is_on[3]) {
      orderedContainers.add(hyper_link_in_main_page(context, "學校講座", "assets/test_back.png", _event));
    }
    if (hyper_link_is_on[4]) {
      orderedContainers.add(hyper_link_in_main_page(context, "請假", "assets/test_back.png", _leave));
    }
    if (hyper_link_is_on[5]) {
      orderedContainers.add(hyper_link_in_main_page(context, "軟體授權", "assets/test_back.png", _csd));
    }
    if (hyper_link_is_on[6]) {
      orderedContainers.add(hyper_link_in_main_page(context, "選課大全", "assets/test_back.png", _no21));
    }
    if (hyper_link_is_on[7]) {
      orderedContainers.add(hyper_link_in_main_page(context, "行事曆", "assets/test_back.png", _oaa));
    }
    if (hyper_link_is_on[8]) {
      orderedContainers.add(hyper_link_in_main_page(context, "圖書館", "assets/test_back.png", _LIB));
    }
    if (hyper_link_is_on[9]) {
      orderedContainers.add(hyper_link_in_main_page(context, "座位預約", "assets/test_back.png", _READ));
    }
    orderedContainers.add(hyper_link_wanted_in_main_page(context, "assets/test_back.png"));
    int length = orderedContainers.length;
    for(int i = 3-(length%3) ; i>0 ; i--){
      orderedContainers.add(hyper_link_empty_in_main_page(context));
    }
    return orderedContainers;
  }

  Widget hyper_link_in_main_page(BuildContext context, String info, String info_picture, Uri link) {
    //一般的快速連結
    return GestureDetector(
      onTap: () => _launchUrl(link),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.26,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Container(
                margin: EdgeInsets.all(3.0),
                width: 50,
                height: 50,
                child: Image.asset(info_picture),
              ),
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget hyper_link_department_in_main_page(BuildContext context, String info,
      String info_picture) {
    //為了"各系網站"所加的dialog
    return GestureDetector(
      onTap: () => _show_department_Dialog(context),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.26,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Container(
                margin: EdgeInsets.all(3.0),
                width: 50,
                height: 50,
                child: Image.asset(info_picture),
              ),
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget hyper_link_wanted_in_main_page(BuildContext context, String info_picture) {
    //後面點選後會跳dialog的格子
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child:Column(
        children: [
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(3),
            color: Color(0xff95b0ce),
            child: Opacity(
              opacity: 0.6,
              child:SizedBox(
                width: MediaQuery.of(context).size.width * 0.26,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.26,
                  decoration: BoxDecoration(
                    color: Color(0xffb9cde3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(3.0),
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color:Color(0xff95b0ce),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  Widget hyper_link_empty_in_main_page(BuildContext context) {
    //後面點選後會跳dialog的格子
    return GestureDetector(
      child:Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.28,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
              ),
            ),
          ),
          Text(
            "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  //給個人快速連結update的處理法
  void updateMainScreen(List<bool> newHyperLinkIsOn) {
    //------不知道為何有了這句就跑得動了???????----------
    setState(() {
      hyper_link_is_on = List.from(newHyperLinkIsOn);
    });
    updateUserHyperlink();
  }

  void _showDialog(BuildContext context) {
    // 給新增個人連結項目的dialog
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
                    updateUserHyperlink();
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
  Widget department(BuildContext context, String name, Uri link) {
    //"各系網站"所加的dialog part 1 統一規格
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.065;
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.12,
          child: ElevatedButton(
            onPressed: () => _launchUrl(link),
            child: Text(
              name,
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
          )
      ),
    );
  }

  Widget class_info(String name, VoidCallback path) {
    //"各系網站"所加的dialog中part 2每個學系的統一規格
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.07;
    if (name.length == 4) textSize = screenWidth * 0.045;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.32,
      height: 70,
      child: ElevatedButton(
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

  void _show_department_Dialog(context) {
    //"各系網站"所加的dialog part 1
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.32,
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () => _launchUrl(_LAW),
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

  void _show_Humanities_Dialog(BuildContext context) {
    //"各系網站"所加的dialog part 2
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
                  department(context, "中國文學系", _CL),
                  department(context, "應用外語學系", _DAFL),
                  department(context, "歷史學系", _HIS),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _show_Bussiness_Dialog(BuildContext context) {
    //"各系網站"所加的dialog part 2
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
                  department(context, "會計學系", _ACC),
                  department(context, "企業管理學系", _DBA),
                  department(context, "金融與合作經營學系", _COOP),
                  department(context, "統計學系", _STAT),
                  department(context, "休閒運動管理學系", _LSM),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _show_Social_Dialog(BuildContext context) {
    //"各系網站"所加的dialog part 2
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
                  department(context, "經濟學系", _ECON),
                  department(context, "社會學系", _SOC),
                  department(context, "社會工作系", _SW),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _show_Public_Dialog(BuildContext context) {
    //"各系網站"所加的dialog part 2
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
                  department(context, "公共行政暨政策學系", _PA),
                  department(context, "財政學系", _FINC),
                  department(context, "不動產與城鄉環境學系", _REBE),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _show_Computer_Dialog(BuildContext context) {
    //"各系網站"所加的dialog part 2
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
                  department(context, "電機工程學系", _EE),
                  department(context, "資訊工程學系", _CS),
                  department(context, "通訊工程學系", _CE),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget hyper_list_dialog_info(String name) {
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
    //orderedContainers.add(_build_main_service_page());
    return orderedContainers;
  }

  //------主要畫面合併--------------------------------------------------------------------------------------

  //----整體建構(畫面與appbar等功能結合)------------------------------------------------------------------------------------------------
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

Future<void> _launchUrl(Uri links) async {
  if (!await launchUrl(links)) {
    throw Exception('Could not launch $links');
  }
}
