import 'dart:math';

import 'package:bybloom_tree/pages/forest_page/forestselectpage.dart';
import 'package:bybloom_tree/pages/profile_page/calendar/calendar_controller.dart';
import 'package:bybloom_tree/pages/profile_page/calendar/calendar_model.dart';
import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'components/mission_container.dart';
import 'mission_controller.dart';
import 'pages/type_A/mission_A_page.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

/// 미션을 확인하고 수행하는 페이지
/// 필요 기능
/// 1. 미션 목록 -> 각 미션 수행 페이지로 이동
/// 2. 미션 완료 여부를 확인할 수 있어야 함.

// 아직 거의 건드리지 않아서 db 연결하면서 같이 수정합시다.
class MissionPage extends GetView<MissionController> {
  const MissionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(MissionController());
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                print(Get
                    .find<ProfileController>()
                    .dayCount
                    .value);
                print(Get
                    .find<ProfileController>()
                    .missionCount
                    .value);
              },
              child: const Text('오늘의 바이블룸',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
          backgroundColor: Colors.white,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [ListView(
            padding: EdgeInsets.fromLTRB(
                Get.width * 0.05, 0, Get.width * 0.05, 100),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(() =>
                    Text(
                      '${controller.day.value} 일째, 데일리 미션입니다',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                ),
              ),
              MissionContainer(type: 'A',),
              MissionContainer(type: 'D',),
              MissionContainer(type: 'C',),
              MissionContainer(type: 'B',),
              SizedBox(height: 10,),
              TextButton(
                  onPressed: () {
                    controller.controller.open();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('지난나눔보기', style: TextStyle(color: Colors.grey),),
                      SizedBox(width: 20),
                      Icon(Icons.folder, color: Colors.grey,)
                    ],
                  ))
              ,
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ForestselectPage()
                      ),
                    );
                  },


                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('미션공유하기', style: TextStyle(color: Colors.grey),),
                      SizedBox(width: 20),
                      Icon(Icons.send, color: Colors.grey,)
                    ],
                  )),


            ],
          ),
          ],
        )
    );
  }
}


///미션완료 메시지 보내기!!
sendmissioncompletedmessage(types.Room room){
types.PartialCustom missioncompleted= types.PartialCustom();
FirebaseChatCore.instance.sendMessage(missioncompleted, room.id);
print("room:$room.id");
}







