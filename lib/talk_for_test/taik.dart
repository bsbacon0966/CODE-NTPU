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

  List<Map<String, dynamic>> _messages = [];

  final ThemeData dynamicTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(color_decide[user_color_decide][2]),
    ),
    scaffoldBackgroundColor: Color(color_decide[user_color_decide][0]),
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    DocumentSnapshot snapshot = await _firestore.collection('talktome').doc('message').get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _messages = List<Map<String, dynamic>>.from(data['messages'] ?? []);
      });
    }
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) {
      return 'Unknown time';
    }

    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$month/$day $hour:$minute';
  }

  Future<void> sendMessage(String name, String context, bool is_creater) async {
    final newMessage = {
      'name': name,
      'context': context,
      'is_creater': is_creater,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    setState(() {
      _messages.insert(0, newMessage);
    });

    await _firestore.collection('talktome').doc('message').set({
      'messages': _messages,
    });
  }

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
                String name = nameController.text.isEmpty ? "(匿名)" : nameController.text;

                if (contextController.text.length > 40) {
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
                  sendMessage(name, contextController.text, false);
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

  void showWarningDialog(String messageId, String info) {
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
                      handleReport(messageId, info, _selectedReason!);
                      ToastService.showSuccessToast(
                        context,
                        length: ToastLength.medium,
                        expandedHeight: 100,
                        message: "感謝你的檢舉，開發者將收到消息並進行處理!",
                      );
                      Navigator.of(context).pop();
                    } else {
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

  Future<void> handleReport(String messageId, String context, ReportReason reason) async {
    await _firestore.collection('warning_for_creater').add({
      'message_id': messageId,
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
          title: Text(
            "測試服:聊天區",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final item = _messages[index];
                  final dateTime = DateTime.fromMillisecondsSinceEpoch(item['timestamp']);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: item['is_creater'] ? Colors.yellow[100] : Colors.blue[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                item['context'],
                                style: TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Text(
                                formatTimestamp(dateTime),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            showWarningDialog(index.toString(), item["context"]);
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
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 60,
          width: 120,
          child: FloatingActionButton(
            onPressed: showInputDialog,
            backgroundColor: Color(color_decide[user_color_decide][3]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              "加入聊天",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}