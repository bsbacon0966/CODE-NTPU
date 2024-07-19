//aaaaaaaaaaaaaaa
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
Future<void> _launchUrl(Uri links) async {
  if (!await launchUrl(links)) {
    throw Exception('Could not launch $links');
  }
}

class ScheduleAndLinks extends StatefulWidget {
  @override
  _ScheduleAndLinks createState() => _ScheduleAndLinks();
}
class _ScheduleAndLinks extends State<ScheduleAndLinks> {
  Widget link_box(BuildContext context, String info, String info_picture, Uri link) {
    return GestureDetector(
      onTap: () => _launchUrl(link),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.42,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.blue[100],
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
                width: 100,
                height: 100,
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

  Widget department(BuildContext context, String name, Uri link) {
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
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }

  void _show_Humanities_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
  }

  void _show_Bussiness_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
  }

  void _show_Social_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
  }

  void _show_Public_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('公共事務學院'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              department(context, "公共行政暨政策學系", _PA),
              department(context, "財政學系", _FINC),
              department(context, "不動產與城鄉環境學系", _SW),
            ],
          ),
        );
      },
    );
  }

  void _show_Computer_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
  }

  void _show_big_Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  class_info("法律", () {
                    Navigator.of(context).pop();
                    _launchUrl(_LAW);
                  }),
                  SizedBox(width: 10),
                  class_info("電機資訊", () {
                    Navigator.of(context).pop();
                    _show_Computer_Dialog(context);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget link_box_with_dialog(BuildContext context, String info, String info_picture) {
    return GestureDetector(
      onTap: () => _show_big_Dialog(context),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.42,
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
                width: 100,
                height: 100,
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

  Widget class_info(String name, VoidCallback path) {
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
  Widget empty_box(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.42,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '數位學院2.0本應該在的QQ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:10.0,top: 10.0),
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Opacity(
                        opacity: 0.6,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Container(
                                width: 27,
                                child: Image.asset(
                                  "assets/resume.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width:5),
                            Text(
                              "學生個人資訊",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "數位學院3.0", "assets/test_back.png", _lms),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "學生資訊系統", "assets/test_back.png", _SIS),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "請假系統", "assets/test_back.png", _leave),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      empty_box(),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:10.0,top: 10.0),
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Opacity(
                        opacity: 0.6,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Container(
                                width: 27,
                                child: Image.asset(
                                  "assets/school_event.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width:5),
                            Text(
                              "學校網站資訊",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "學校講座報名", "assets/test_back.png", _event),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box_with_dialog(context, "各系網站", "assets/test_back.png"),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "北大軟體授權網", "assets/test_back.png", _csd),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "北大行事曆", "assets/test_back.png", _oaa),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:10.0,top: 10.0),
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Opacity(
                        opacity: 0.6,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Container(
                                width: 27,
                                child: Image.asset(
                                  "assets/book-stack.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width:5),
                            Text(
                              "圖書館系列",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "圖書館登入", "assets/test_back.png", _LIB),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "圖書館座位預約", "assets/test_back.png", _READ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:10.0,top: 10.0),
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Opacity(
                      opacity: 0.6,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: Container(
                              width: 27,
                              child: Image.asset(
                                "assets/internet.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width:5),
                          Text(
                            "學長姊留下來的好用網站",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      link_box(context, "選課大全", "assets/test_back.png", _no21),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      empty_box(),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ],

            ),
          ],
        ),
      ),
    );
  }
}