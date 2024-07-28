import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewer/main_page/School_Table/SchoolTableTimeDeleteTasks.dart';
import 'package:interviewer/main_page/main_first.dart';
import 'package:interviewer/personal_menu/Personal_Menu.dart';
import 'package:interviewer/main_page/main_second.dart';

import '../main_page/School_Table/SchoolTableTime.dart';
final User? currentUser = FirebaseAuth.instance.currentUser;
Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetail() async{
  return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
}

Future<void> updateUserHyperlink() async {
  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "favorite_hyperlink": hyper_link_is_on,
    });
  }
}

Future<void> updateUserFavoriteService() async {
  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "favorite_service": pinned,
    });
  }
}
//["課程",1,9,0,3, "WEEKLY", 1, "MO", "多媒體技術", "資B104",2],
Future<void> updateUserPersonalSchedule() async { //將dynamic的資料型態轉成map並給每個元素分別上標籤
  if (currentUser != null) {
    List<Map<String, dynamic>> flattenedSchedule = personal_schedule_info.map((task) {
      return {
        "type": task[0],
        "semester": task[1],
        "start_hour": task[2],
        "start_minute": task[3],
        "duration_hours": task[4],
        "day_abbr": task[5],
        "interval": task[6],
        "day": task[7],
        "class_info":task[8],
        "class_location":task[9],
        "class_duration":task[10],
      };
    }).toList();//將多樣事物轉成list

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "personal_schedule": flattenedSchedule,
    });
  }
}
Future<void> updateUserPersonalScheduleDelete() async { //將dynamic的資料型態轉成map並給每個元素分別上標籤
  if (currentUser != null) {
    List<Map<String, dynamic>> flattenedSchedule = personal_schedule_info_delete.map((task) {
      return {
        "type": task[0],
        "semester": task[1],
        "start_hour": task[2],
        "start_minute": task[3],
        "duration_hours": task[4],
        "day_abbr": task[5],
        "interval": task[6],
        "day": task[7],
        "class_info":task[8],
        "class_location":task[9],
        "class_duration":task[10],
      };
    }).toList();//將多樣事物轉成list

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "personal_schedule": flattenedSchedule,
    });
  }
}

Future<void> loadUserHyperlink() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> favoriteHyperlink = doc.data()?['favorite_hyperlink'];
      hyper_link_is_on = List<bool>.from(favoriteHyperlink);
    }
  }
}
Future<void> loadUserPersonalScheduleDelete() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> scheduleData = doc.data()?['personal_schedule'] ?? [];
      personal_schedule_info_delete = scheduleData.map((task) { // 把map拆回成List<dynamic>
        return [
          task["type"],
          task["semester"],
          task["start_hour"],
          task["start_minute"],
          task["duration_hours"],
          task["day_abbr"],
          task["interval"],
          task["day"],
          task["class_info"],
          task["class_location"],
          task["class_duration"],
        ];
      }).toList();
    }
  }
}

Future<void> loadUserPersonalSchedule() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> scheduleData = doc.data()?['personal_schedule'] ?? [];
      personal_schedule_info = scheduleData.map((task) { // 把map拆回成List<dynamic>
        return [
          task["type"],
          task["semester"],
          task["start_hour"],
          task["start_minute"],
          task["duration_hours"],
          task["day_abbr"],
          task["interval"],
          task["day"],
          task["class_info"],
          task["class_location"],
          task["class_duration"],
        ];
      }).toList();
    }
  }
}

Future<void> loadUserFavoriteService() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> favoriteService = doc.data()?['favorite_service'];
      pinned = List<bool>.from(favoriteService);
    }
  }
}

Future<void> loadUserSchoolID() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      schoolID_on_menu = doc.data()?['schoolID'];
    }
  }
}

/*
Future<void> updateUserHyperlink() async {
  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "favorite_hyperlink": hyper_link_is_on,
    });
  }
}

Future<void> loadUserHyperlink() async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> doc = await getUserDetail();
    if (doc.exists) {
      List<dynamic> favoriteHyperlink = doc.data()?['favorite_hyperlink'];
      hyper_link_is_on = List<bool>.from(favoriteHyperlink);

      // 檢查和補齊長度
      while (hyper_link_is_on.length < 4) {
        hyper_link_is_on.add(false);
      }

      // 如果有更新，保存回Firestore
      if (favoriteHyperlink.length < 4) {
        await updateUserHyperlink();
      }
    }
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetail() async {
  return await FirebaseFirestore.instance
      .collection("Users")
      .doc(currentUser!.email)
      .get();
}
 */