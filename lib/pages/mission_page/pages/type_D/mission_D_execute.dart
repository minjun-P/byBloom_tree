
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MissionDExecute extends GetView<MissionController> {
  const MissionDExecute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('오늘의 예배'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                const SizedBox(height: 40,),
                const Text('어떻게 예배를 드리셨나요?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(()=>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [0,1,2].map((index){
                        return Column(
                          children: [
                            Text(controller.prayerCategory[index],style: const TextStyle(fontWeight: FontWeight.bold),),
                            Radio<String>(
                                value: controller.prayerCategory[index],
                                groupValue: controller.prayerCategory[controller.prayerIndex.value],
                                onChanged: (element) {
                                  controller.prayerIndex(index);
                                },
                            ),
                          ],
                        );
                      }).toList()
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('느낀 점을 적어주세요!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                  child: TextFormField(
                    controller: controller.missionControllerD,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: '여기에 적어주세요',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 60,),
                ElevatedButton(
                  onPressed: (){

                    if (controller.missionControllerD.text.isNotEmpty){
                      // db 업데이트
                      controller.updateComplete(
                          comment: controller.missionControllerD.text,
                          type: 'D',
                          prayerCategory: controller.prayerCategory[controller.prayerIndex.value]
                      );
                      Get.back();
                      controller.clearMission();
                      controller.missionControllerD.clear();

                      // snack 바와 경험치 상승

                    }
                  },
                  child: const Text('제출하기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffA0C6FF),
                      fixedSize: Size(Get.width*0.7,50)
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
