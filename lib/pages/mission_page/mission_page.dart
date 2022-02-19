import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: const Text('오늘의 미션',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        controller: controller.scrollController,
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 40, Get.width*0.05, 100),
        children: [
          // 당일의 미션 3개 - 컨테이너 - 아래 메소드로 구현해놓음
          _buildMissionContainer(0),
          _buildMissionContainer(1),
          _buildMissionContainer(2),
        ],
      ),
    );
  }

  Widget _buildMissionContainer(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //명시적으로 text가 차지할 영역 정해주기
            width: Get.width*0.6,
              padding: const EdgeInsets.only(left: 40),
              child: Text(controller.missionList[index])
          ),
          SizedBox(width: Get.width*0.1),
          _buildMissionCompleteBox(index),
          SizedBox(width: Get.width*0.1,)

        ],
      ),
    );
  }

  Widget _buildMissionCompleteBox(int index) {
    return Obx(()=>GestureDetector(
      onTap: (){
        controller.updateMissionComplete(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: controller.missionComplete[index]?33:32,
        height: controller.missionComplete[index]?33:32,
        decoration: BoxDecoration(
          border: controller.missionComplete[index]
              ?Border.all(color:Colors.green,width: 2)
              :Border.all(color:Colors.grey,width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        curve: Curves.linearToEaseOut,
        child: controller.missionComplete[index]?const Icon(Icons.park,color: Colors.green,):null,

      ),
    ));
  }
}
