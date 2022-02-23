import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission2/mission2_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission2/mission_survey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 일일미션2 - 바이블룸 앙케이트
class Mission2 extends GetView<Mission2Controller> {
  const Mission2({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(Mission2Controller());
    return SafeArea(
      child: Obx(()=> Scaffold(
          floatingActionButton: controller.submitted.value
              ?FloatingActionButton(
            child: Text('다시'),
            onPressed: () {
              controller.submitted(!controller.submitted.value);
            },
          )
              :FloatingActionButton(
            child: Text('제출'),
            onPressed: (){
              if (controller.selected.value==0){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  title: '선택지를 클릭해주세요!'
                ).show();
              } else{
                controller.submitted(!controller.submitted.value);
              }
            },
          ),
          body: Center(
            child: MissionSurvey(title: '제일 좋아하는 성경 속 인물은??',)
          ),
        ),
      ),
    );
  }
}
