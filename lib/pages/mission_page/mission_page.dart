import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mission_controller.dart';
import 'components/calendar.dart';

class MissionPage extends GetView<MissionController> {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MissionController());
    return Container(
      color: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 40, Get.width*0.05, 100),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('데일리 블룸',style: context.textTheme.headline1,),
              SizedBox(width: 15,),
              Text('12.23',style: context.textTheme.headline2,)
            ],
          ),
          SizedBox(height: 10,),
          // 당일의 미션 3개 - 컨테이너 - 메소드로 구현해놓음
          _buildMissionContainer(0),
          _buildMissionContainer(1),
          _buildMissionContainer(2),
          SizedBox(height: 15,),
          Text('나의 기록',style: context.textTheme.headline1,),
          SizedBox(height: 10,),
          Calendar(),
        ],
      ),
    );
  }

  Widget _buildMissionContainer(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //명시적으로 text가 차지할 영역 정해주기
            width: Get.width*0.6,
              padding: EdgeInsets.only(left: 40),
              child: Text(controller.missionList[index])
          ),
          SizedBox(width: Get.width*0.1),
          _buildMissitonCompleteBox(index),
          SizedBox(width: Get.width*0.1,)

        ],
      ),
    );
  }

  Widget _buildMissitonCompleteBox(int index) {
    return Obx(()=>GestureDetector(
      onTap: (){
        controller.updateMissionComplete(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: controller.missionComplete[index]?33:32,
        height: controller.missionComplete[index]?33:32,
        decoration: BoxDecoration(
          border: controller.missionComplete[index]
              ?Border.all(color:Colors.green,width: 2)
              :Border.all(color:Colors.grey,width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        curve: Curves.linearToEaseOut,
        child: controller.missionComplete[index]?Icon(Icons.park,color: Colors.green,):null,

      ),
    ));
  }
}
