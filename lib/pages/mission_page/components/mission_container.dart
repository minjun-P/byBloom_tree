import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mission_controller.dart';
class MissionContainer extends GetView<MissionController> {
  final int index;
  const MissionContainer({
    Key? key,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Rx<Mission>> missionList = [controller.mission1,controller.mission2,controller.mission3];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: (){
                Get.to(missionList[index].value.route);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    //명시적으로 text가 차지할 영역 정해주기
                      child: Text(
                          missionList[index].value.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  ),
                  SizedBox(
                      child: Text(missionList[index].value.desc)
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: Get.width*0.1),
          Flexible(
            flex: 1,
              child: _buildMissionCompleteBox(index)
          ),

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
