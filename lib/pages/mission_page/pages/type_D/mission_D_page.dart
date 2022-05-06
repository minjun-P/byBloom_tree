import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mission_D_execute.dart';

class MissionDPage extends GetView<MissionController> {
  const MissionDPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Image.asset('assets/pray.png',width: 200,),
              const Text(
                '오늘의 예배',
                style: TextStyle(fontSize: 24,),
              ),

              Flexible(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('오늘의 예배에 참석하셨나요',style: TextStyle(fontSize: 17),),
                    Text('예배의 느낀 점을 간단히 정리해볼까요?',style: TextStyle(fontSize: 17),),
                    SizedBox(height: 10,),
                    Text('느낀 점은 기록함에'),
                    Text('저장되며 공개되지 않습니다.')
                  ],
                ),
              ),
              const Spacer(flex: 5,),
              Obx(()=>
                  ElevatedButton(
                    onPressed: controller.missionCompleted['D']!
                        ?(){}
                        :(){
                      Get.to(()=>const MissionDExecute());
                    },
                    child: controller.missionCompleted['D']!
                        ?const Text('작성 완료!',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)
                        :const Text('느낀점 남기기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
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
