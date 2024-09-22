import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewer/color_decide.dart';
import 'package:interviewer/firebase_store/fire_store_for_loading_personal_data.dart';
import 'package:quickalert/quickalert.dart';
import '../main_page_and_menu/main_page_and_menu_initial.dart';

class PersonalInfoAdjust extends StatefulWidget {
  const PersonalInfoAdjust({Key? key}) : super(key: key);

  @override
  State<PersonalInfoAdjust> createState() => _PersonalInfoAdjustState();
}

class _PersonalInfoAdjustState extends State<PersonalInfoAdjust> {
  int _selectedOption = user_color_decide;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(color_decide[user_color_decide][2]),
          elevation: 0,
        ),
        scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '色調調整',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '選擇您喜歡的顏色主題',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ...List.generate(3, (index) => _buildColorThemeCard(index)),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(color_decide[user_color_decide][2]),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "確定結果",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorThemeCard(int themeIndex) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => setState(() => _selectedOption = themeIndex),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: List.generate(
                  4,
                      (index) => Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(color_decide[themeIndex][index]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Radio<int>(
                    value: themeIndex,
                    groupValue: _selectedOption,
                    onChanged: (value) => setState(() => _selectedOption = value!),
                    activeColor: Color(color_decide[user_color_decide][3]),
                  ),
                  Text('主題 ${themeIndex + 1}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: '確認更改',
      text: '您確定要更改顏色主題嗎？',
      confirmBtnText: '確認',
      cancelBtnText: '取消',
      confirmBtnColor: Color(color_decide[user_color_decide][2]),
      onConfirmBtnTap: () async {
        user_color_decide = _selectedOption;
        await updateUserColorDecide();
        Get.off(() => TheBigTotalPage(selectedIndex: 0));
      },
    );
  }
}