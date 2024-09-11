import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../main_page_and_menu/main_page_and_menu_initial.dart';

class PersonalInfoAdjust extends StatefulWidget {
  const PersonalInfoAdjust({super.key});

  @override
  State<PersonalInfoAdjust> createState() => _PersonalInfoAdjustState();
}

class _PersonalInfoAdjustState extends State<PersonalInfoAdjust> {
  int _selectedOption = user_color_decide;  // Initialize with current user_color_decide value
  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );


  Widget color_bar(int value,int a,int b,int c,int d){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<int>(
          value: value,
          groupValue: _selectedOption,
          onChanged: (int? value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: Color(color_decide[user_color_decide][3]),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.width*0.2,
          decoration: BoxDecoration(
            color: Color(a),  // Set the background color to red
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.width*0.2,
          decoration: BoxDecoration(
            color: Color(b),  // Set the background color to red
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.width*0.2,
          decoration: BoxDecoration(
            color: Color(c),  // Set the background color to red
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.width*0.2,
          decoration: BoxDecoration(
            color: Color(d),  // Set the background color to red
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply the dynamic theme
        data: dynamicTheme,
        child:Scaffold(
          appBar: AppBar(
              title: Text(
                  'Personal Info Adjust',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          ),
          body:SingleChildScrollView(  // Allows scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                color_bar(0,color_decide[0][0], color_decide[0][1], color_decide[0][2], color_decide[0][3]),
                //  [0xfff0f3fc,0xffa1bade,0xff95b0ce,0xff739abe],
                SizedBox(height: 15,),
                color_bar(1,color_decide[1][0], color_decide[1][1], color_decide[1][2], color_decide[1][3]),
                SizedBox(height: 15,),
                //  [0xffF8EDE3,0xffDFD3C3,0xffD0B8A8,0xffC5705D]
                color_bar(2,color_decide[2][0], color_decide[2][1], color_decide[2][2], color_decide[2][3]),
                SizedBox(height: 15,),
                ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: '資訊將上傳，是否確定?',
                        text: '確定前，上述操作皆不會被記錄',
                        confirmBtnText: '確認',
                        cancelBtnText: '取消',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () async {
                          user_color_decide = _selectedOption;
                          await updateUserColorDecide();
                          Get.to(TheBigTotalPage(selectedIndex: 0));
                        },
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "確定結果",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
