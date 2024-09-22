import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import '../main_page_and_menu/main_page_and_menu_initial.dart';
import '../login/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget customTextField(String info, TextEditingController controller_info, bool isobscure, IconData icon_form) {
    return TextFormField(
      controller: controller_info,
      decoration: InputDecoration(
        hintText: info,
        prefixIcon: Icon(icon_form),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: isobscure,
    );
  }

  Future<void> loginUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (emailController.text.isEmpty) {
      Navigator.pop(context);
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Email不可為空",
      );
    } else if (passwordController.text.isEmpty) {
      Navigator.pop(context);
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "密碼不可為空",
      );
    } else {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        Get.off(() => TheBigTotalPage(), transition: Transition.rightToLeft); // Use Get.off() to prevent back navigation
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        ToastService.showErrorToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: e.message ?? "登入失敗",
        );
      }
    }
  }

  void initState() {
    super.initState();
    // 在初始化時顯示警告窗
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWarningDialog();
    });
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('測試服注意事項'),
        content: Text(
        '1. 此測試服將從9/21開放至10/1 23:59，之後將會把資料庫完全刪除，您的任何資料將不會保留，並且將無法登入\n\n'
            '2. 為了能夠記錄您在App中的操作（如您的課表資訊等），我們會收集您註冊時所使用的Email。請放心，此舉僅用於方便記錄個人操作資料，絕無意圖干涉或操控您的個人資訊。\n\n'
            '3. 有任何問題還請回應給我!\n\n'
            '4. 現階段製作人仍僅有一人進行開發與維護，製作不易，還請給予我鼓勵以及諒解!!',
            style: TextStyle(
              fontSize: 16,
            ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('我知道了'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f3fc),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.person,
                size: 120,
                color: Color(0xff739abe),
              ),
            ),
            Text(
              "CODE:NTPU",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w600,
                color: Color(0xff739abe),
              ),
            ),
            SizedBox(height: 24),
            customTextField("Email", emailController, false, Icons.email),
            SizedBox(height: 16),
            customTextField("Password", passwordController, true, Icons.lock),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 60,
              child: ElevatedButton(
                onPressed: loginUser,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Doesn't have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff739abe),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterPage(), transition: Transition.rightToLeft);
                  },
                  child: Text(
                    " Register here!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff739abe),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
