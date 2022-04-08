
import 'package:bybloom_tree/pages/mission_page/pages/type_B/prior_mission_B.dart';

import 'dart:math';

import 'package:bybloom_tree/pages/forest_page/forestselectpage.dart';

import 'package:bybloom_tree/pages/profile_page/calendar/calendar_controller.dart';
import 'package:bybloom_tree/pages/profile_page/calendar/calendar_model.dart';
import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
          },
            child: const Text('오늘의 바이블룸',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 0, Get.width*0.05, 100),
        children: [
          MissionContainer(type: 'A',),
          MissionContainer(type: 'D',),
          MissionContainer(type: 'C',),
          MissionContainer(type: 'B',),
          SizedBox(height: 120,),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                Get.to(()=>PriorMissionB());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('지난 나눔 보기',style: TextStyle(color: Colors.grey,fontSize: 20),),
                  SizedBox(width: 10,),
                  Icon(MdiIcons.folder,color: Colors.grey.shade300,size: 30,)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForestselectPage()
                  ),
                );




              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('숲으로 공유하기',style: TextStyle(color: Colors.grey,fontSize: 20),),
                  SizedBox(width: 10,),
                  Icon(MdiIcons.send,color: Colors.grey.shade300,size: 30,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}









