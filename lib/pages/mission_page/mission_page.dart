import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    List missionList = [controller.mission1, controller.mission2, controller.mission3];
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 미션',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 40, Get.width*0.05, 100),
        children: [
          // 당일의 미션 3개 - 컨테이너 - 아래 메소드로 구현해놓음
          MissionContainer(index:0),
          MissionContainer(index: 1),
          MissionContainer(index: 2)
        ],
      ),
    );
  }  
}
