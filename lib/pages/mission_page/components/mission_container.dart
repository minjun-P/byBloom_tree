import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_C/mission_C_page.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_D/mission_D_page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mission_controller.dart';
import '../pages/type_A/mission_A_page.dart';
import '../pages/type_B/mission_B_page.dart';
class MissionContainer extends GetView<MissionController> {
  final String type;
  const MissionContainer({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        switch(type) {
          case 'A':
            Get.to(()=>MissionAPage());
            break;
          case 'B':
            Get.to(()=>MissionBPage());
            break;
          case 'C':
            Get.to(()=>MissionCPage());
            break;
          case 'D':
            Get.to(()=>MissionDPage());
            break;

        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
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
                  controller.typeMatch[type],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),

              )
            ),
            Flexible(
              flex: 1,
                child: _buildMissionCompleteBox(type)
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildMissionCompleteBox(String type) {
    return Obx(()=>AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: controller.missionCompleted[type]!
            ?Color(0xff5B5B5B)
            :Colors.grey.shade200
      ),
      curve: Curves.linearToEaseOut,
      child: controller.missionCompleted[type]!?const Icon(Icons.check,color: Colors.white,):null,

    ));
  }
}
