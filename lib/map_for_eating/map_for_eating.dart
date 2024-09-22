import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'dart:math';
import 'package:interviewer/color_decide.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class FortuneWheelDemo extends StatefulWidget {
  @override
  _FortuneWheelDemoState createState() => _FortuneWheelDemoState();
}

class _FortuneWheelDemoState extends State<FortuneWheelDemo> with SingleTickerProviderStateMixin {
  int selectedValue = 0;
  final List<String> items = [
    '麥當勞', '蕉阿吐司', '韓一', '八方', 'Thai Le泰料', 'A華滷味',
  ];
  final List<Color> colors = [
    Color(color_decide[user_color_decide][1]),
    Color(color_decide[user_color_decide][2]),
    Color(color_decide[user_color_decide][3]),
    Color(color_decide[user_color_decide][1]),
    Color(color_decide[user_color_decide][2]),
    Color(color_decide[user_color_decide][3]),
  ];
  StreamController<int> selectedController = StreamController<int>();
  bool isSpinning = false;
  bool hasSpun = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    selectedController.close();
    _animationController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
        hasSpun = true;
        selectedValue = Random().nextInt(items.length);
        selectedController.add(selectedValue);
      });

      _animationController.forward();

      Timer(Duration(seconds: 5), () {
        _showResultDialog();
        setState(() {
          isSpinning = false;
        });
      });
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('轉盤結果', style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant, size: 50, color: colors[selectedValue]),
              SizedBox(height: 20),
              Text('你選到了：', style: GoogleFonts.notoSans()),
              Text(
                items[selectedValue],
                style: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.bold, color: Color(color_decide[user_color_decide][3])),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('確定', style: GoogleFonts.notoSans()),
              onPressed: () {
                _animationController.reverse();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );
  @override
  Widget build(BuildContext context) {
    return  Theme(
        data: dynamicTheme,
        child:
        Scaffold(
          appBar: AppBar(
            title: Text(
                "午餐吃甚麼",
                style: TextStyle(
                    color: Colors.white
                )
            ),
            elevation: 0,
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ScaleTransition(
                      scale: _animation,
                      child: FortuneWheel(
                        selected: selectedController.stream,
                        animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: Duration(seconds: 1),
                          curve: Curves.decelerate,
                        ),
                        onFling: _spinWheel,
                        items: [
                          for (int i = 0; i < items.length; i++)
                            FortuneItem(
                              child: Text(
                                  items[i],
                                  style: GoogleFonts.notoSans(
                                    color: Colors.white,
                                    fontSize: 32,
                                  )
                              ),
                              style: FortuneItemStyle(
                                color: colors[i],
                                borderWidth: 3,
                                borderColor: Colors.white,
                              ),
                            ),
                        ],
                        styleStrategy: UniformStyleStrategy(
                          borderColor: Colors.white,
                          borderWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: isSpinning ? null : _spinWheel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: isSpinning
                          ? SpinKitRing(color: Colors.white, size: 24.0)
                          : Text('開始旋轉', style: GoogleFonts.notoSans(fontSize: 18)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}