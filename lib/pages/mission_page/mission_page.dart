
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_B/prior_mission_B.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';


import 'package:bybloom_tree/pages/forest_page/forestselectpage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'components/mission_container.dart';
import 'mission_controller.dart';


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
        title: const Text('데일리 블룸',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 0, Get.width*0.05, 100),
        children: [
          MissionContainer(type: 'A',key: Get.find<MainController>().tutorialKey7,),
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

                if(!MissionController().missionCompleted.containsValue(false)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ForestselectPage()
                    ),
                  );
                }
                if(MissionController().missionCompleted.containsValue(false)){
                  Fluttertoast.showToast(
                      msg: "아직 완료하지못한 오늘의 미션이 있습니다",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }


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









