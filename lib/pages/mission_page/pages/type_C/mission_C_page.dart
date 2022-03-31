import 'package:bybloom_tree/pages/mission_page/pages/type_C/mission_C_execute.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mission_controller.dart';

class MissionCPage extends StatelessWidget {
  const MissionCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/pray.png',width: 200,),
              Text(
                  '오늘의 감사 일기',
                  style: TextStyle(fontSize: 24,),
              ),
              Spacer(flex: 3,),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('오늘 하루 감사했던 일이 있었나요?',style: TextStyle(fontSize: 17),),
                    Text('하루를 정리하며 짧은 일기를 써주세요:)',style: TextStyle(fontSize: 17),),
                    SizedBox(height: 10,),
                    Text('( 이 미션은 내 기록함에서 저장되며 공개되지 않습니다. )')
                  ],
                ),
              ),
              Spacer(flex: 10,),
              !Get.find<MissionController>().missionCompleted['C']!
                  ?ElevatedButton(
                onPressed: (){
                  Get.to(()=>MissionCExecute());
                },
                child: Text('쓰러가기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xffA0C6FF),
                    fixedSize: Size(Get.width*0.7,50)
                ),
              )
              :Container(
                alignment: Alignment.center,
                  child: Text('일기 작성 완료!',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                width: Get.width*0.7,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffA0C6FF)
                ),
              ),
              Spacer(flex: 5,)

            ],
          ),
        ),
      ),
    );
  }
}
