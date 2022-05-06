import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_B/not_selection_answer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'selection_answer.dart';


class MissionBPage extends GetView<MissionController> {
  const MissionBPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/pray.png',
                width: 200,
              ),
              const Text('오늘의 나눔미션',style: TextStyle(fontSize: 24),),
              const SizedBox(height: 20,),
              SizedBox(
                height: 100,
                width: Get.width*0.7,
                child: const Text(
                  '여러분의 생각을 나누는 공간입니다.\n어떤 의견이든 좋으니 가볍게 여러분의 생각을 알려주세요!'
                ),
              ),
              const Spacer(flex: 5,),
              Obx(()=>
                  ElevatedButton(
                    onPressed: (){
                      if (controller.missionB['객관식']){
                        Get.to(()=>SelectionAnswer(prior: false,missionData: controller.missionB,day: controller.day.value,));
                      } else{
                        Get.to(()=>NoSelectionAnswer(prior: false,missionData: controller.missionB,day: controller.day.value,));
                      }

                    },
                    child: controller.missionCompleted['B']!
                        ?const Text('의견 구경하기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)
                        :const Text('의견 남기기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffA0C6FF),
                        fixedSize: Size(Get.width*0.7,50)
                    ),
                  ),
              ),
              const Spacer(flex: 3,)
            ],
          ),
        ),
      ),
    );
  }
}
