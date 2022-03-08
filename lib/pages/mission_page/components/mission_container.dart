import 'package:bybloom_tree/pages/mission_page/pages/draggable.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission_exexcute_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mission_controller.dart';
import '../pages/draggable_page.dart';
class MissionContainer extends GetView<MissionController> {
  final int index;
  const MissionContainer({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Mission mission = missionList[index];
    return GestureDetector(
      onTap: (){
        Get.to(()=>MissionExecutePage(mission: mission));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2,2),
              blurRadius: 3,
              spreadRadius: 0
            )
          ]
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Text(
                mission.title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 20
                ),
              ),
            ),
            Flexible(
              flex: 1,
                child: _buildMissionCompleteBox(index)
            ),

          ],
        ),
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
        width: 32,
        height: 32,
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
