import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_C/mission_C_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionCExecute extends GetView<MissionCController> {
  const MissionCExecute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MissionCController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          actions: [
            Center(
                child:
                  GestureDetector(
                    onTap: (){
                      controller.uploadMissionC(controller.textEditingController.text);
                      controller.textEditingController.clear();
                      Get.back();
                      Get.find<MissionController>().clearMission();
                    },
                    child: Text(
                      '저장하기',
                      style: TextStyle(color: Colors.grey.shade600,fontSize: 18),
                    ),
                  )
            ),
            SizedBox(width: 20,)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: TextFormField(
            controller: controller.textEditingController,
            expands: true,
            minLines: null,
            maxLines: null,
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: '오늘 하루 감사했던 것들을 적어주세요',
              border: InputBorder.none
            ),
          ),
        ),
      ),
    );
  }
}
