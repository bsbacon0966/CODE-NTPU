import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../color_decide.dart';

class TalkToMe extends StatefulWidget {
  const TalkToMe({super.key});

  @override
  State<TalkToMe> createState() => _TalkToMeState();
}

enum ReportReason { inappropriate, biased, falseAdvertising }

class _TalkToMeState extends State<TalkToMe> {
  ReportReason? _selectedReason;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contextController = TextEditingController();

  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );

  // Function to send the message to Firestore
  Future<void> sendMessage(String name, String context, bool is_creater) async {
    await _firestore.collection('talk_to_me').add({
      'name': name,
      'context': context,
      'is_creater':false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Function to show the dialog for input
  void showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("你的留言，所有人都看的到"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: '輸入名字(無資訊視為"匿名")'),
              ),
              TextField(
                controller: contextController,
                decoration: InputDecoration(labelText: '輸入內容(限40字)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                String name;
                if (nameController.text.isEmpty) {
                  name = "(匿名)";
                } else {
                  name = nameController.text;
                }

                if (contextController.text.length > 40) {
                  // 顯示錯誤訊息
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('錯誤'),
                        content: Text('內容超過40字，請縮短內容。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('確定'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  sendMessage(name, contextController.text,false);
                  nameController.clear();
                  contextController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('送出'),
            ),
          ],
        );
      },
    );
  }

  void showWarningDialog(String docID, String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("選擇檢舉事由"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("重傷、不雅詞彙出現"),
                    leading: Radio<ReportReason>(
                      value: ReportReason.inappropriate,
                      groupValue: _selectedReason,
                      onChanged: (ReportReason? value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("帶有偏見、歧視言論"),
                    leading: Radio<ReportReason>(
                      value: ReportReason.biased,
                      groupValue: _selectedReason,
                      onChanged: (ReportReason? value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("不實廣告宣傳(正常社團活動不算)"),
                    leading: Radio<ReportReason>(
                      value: ReportReason.falseAdvertising,
                      groupValue: _selectedReason,
                      onChanged: (ReportReason? value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedReason != null) {
                      handleReport(docID, info, _selectedReason!);
                      ToastService.showSuccessToast(
                        context,
                        length: ToastLength.medium,
                        expandedHeight: 100,
                        message: "感謝你的檢舉，開發者將收到消息並進行處理!",
                      );
                      Navigator.of(context).pop();
                    } else {
                      // Show error if no option is selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('錯誤'),
                            content: Text('請選擇一個檢舉事由。'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('確定'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('確認'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> handleReport(String docID, String context, ReportReason reason) async {
    await _firestore.collection('warning_for_creater').add({
      'context_ID': docID,
      'context_info': context,
      'reportReason': reason.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: dynamicTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text("測試服:聊天區"),
        ),
        body: Column(
          children: [
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: Color(color_decide[user_color_decide][3]),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    offset: Offset(5, 5),
                  ),
                ],
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  showInputDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(color_decide[user_color_decide][3]),
                ),
                child: Text(
                  "我要新增資訊",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('talk_to_me')
                    .orderBy('timestamp', descending: true) // Ordering by timestamp
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }

                  final dataList = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'docID': doc.id,
                      'name': data['name'] ?? '',
                      'context': data['context'] ?? '',
                      'isCreater':data['is_creater']??false,
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(12.0),
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          color: item['isCreater']? Colors.limeAccent[100]:Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Flexible(
                                    child: Text(
                                      item['context'] ?? 'No Context',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                      maxLines: 3, // Limit to 3 lines for content
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showWarningDialog(item["docID"], item["context"]);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(50, 50),
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}