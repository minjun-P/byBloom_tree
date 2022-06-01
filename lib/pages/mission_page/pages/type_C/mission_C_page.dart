import 'package:bybloom_tree/pages/mission_page/pages/type_C/mission_C_execute.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mission_controller.dart';

class MissionCPage extends GetView<MissionController> {
  const MissionCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(

            children: [

              Image.asset('assets/pray.png',width: 200,),
              const Text(
                  '오늘의 감사 일기',
                  style: TextStyle(fontSize: 24,),
              ),
             
              Flexible(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('오늘 하루 감사했던 일이 있었나요?',style: TextStyle(fontSize: 17),),
                    Text('하루를 정리하며 짧은 일기를 써주세요:)',style: TextStyle(fontSize: 17),),
                    SizedBox(height: 10,),
                    Text('이 미션은 내 기록함에서'),
                    Text('저장되며 공개되지 않습니다.')
                  ],
                ),
              ),
              const Spacer(flex: 5,),
              Obx(()=>
                ElevatedButton(
                  onPressed: controller.missionCompleted['C']!
                      ?(){}
                      :(){
                    Get.to(()=>const MissionCExecute());
                  },
                  child: controller.missionCompleted['C']!
                      ?const Text('일기 작성 완료!',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)
                      :const Text('쓰러가기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffA0C6FF),
                      fixedSize: Size(Get.width*0.7,50)
                  ),
                ),
              ),
              const Spacer(flex: 3,),

            ],
          ),
        ),
      ),
    );
  }
}
