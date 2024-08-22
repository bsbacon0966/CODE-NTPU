
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../color_decide.dart';
import '../firebase_store/fire_store_for_loading_personal_data.dart';
import '../firebase_store/fire_store_for_news.dart';
import '../main_page/School_Table/SchoolTableTime.dart';
import '../main_page/main_first.dart';
import '../main_page/main_second.dart';
import '../main_page/schedule.dart';
import '../personal_menu/Personal_Menu.dart';

class TheBigTotalPage extends StatefulWidget {
  final int selectedIndex;

  TheBigTotalPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _TheBigTotalPageState createState() => _TheBigTotalPageState();
}
class _TheBigTotalPageState extends State<TheBigTotalPage> {
  late int _selectedIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize _selectedIndex with the passed argument
    loadUserData();
  }

  Future<void> loadUserData() async {
    await loadUserHyperlink();
    await loadUserSchoolID();
    await loadUserColorDecide();
    await loadNews();
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return the_total_page();
      case 1:
        return ScheduleInMain();
      case 2:
        return Schooltabletime();
      case 3:
        return the_total_page_2();
      default:
        return the_total_page();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 動態調整appbar跟常用背景，讓他們兩個吃的到FIREBASE資訊
    final ThemeData dynamicTheme = ThemeData(
      appBarTheme: AppBarTheme(
        color: Color(color_decide[user_color_decide][2]),
      ),
      scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
    );

    return Theme(
      data: dynamicTheme,//動態調整結果
      child: ZoomDrawer(
        showShadow: true,
        menuBackgroundColor: Color(color_decide[user_color_decide][3]),
        menuScreen: MenuPage(),
        mainScreen: Scaffold(
          body: _getPage(_selectedIndex),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Color(color_decide[user_color_decide][2]),
            items: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: _selectedIndex == 0 ? 32 : 20,
                      color: Colors.white,
                    ),
                    Text('首頁', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: _selectedIndex == 1 ? 32 : 20,
                      color: Colors.white,
                    ),
                    Text('行事曆', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: _selectedIndex == 2 ? 32 : 20,
                      color: Colors.white,
                    ),
                    Text('課表', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: _selectedIndex == 3 ? 32 : 20,
                      color: Colors.white,
                    ),
                    Text('服務', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            ],
            index: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        angle: 0,
      ),
    );
  }
}

//------menu跟主要畫面合併------------------------------------------------------------------------------------