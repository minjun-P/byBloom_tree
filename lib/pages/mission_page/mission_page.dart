import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/mission_container.dart';
import 'mission_controller.dart';
import 'bible_model.dart';

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
            controller.getFruit();
          },
            child: const Text('오늘의 바이블룸',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
        actions: [Obx(()=> Text(controller.day.value.toString(), style: TextStyle(color: Colors.black),),),SizedBox(width: 30,)],
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 20, Get.width*0.05, 100),
        children: [
          MissionContainer(index:0),
          MissionContainer(index: 1,),
          MissionContainer(index: 2),
          MissionContainer(index:3),
        ],
      ),
    );
  }  
}
