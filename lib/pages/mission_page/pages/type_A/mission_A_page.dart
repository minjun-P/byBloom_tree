import 'package:bybloom_tree/pages/mission_page/pages/type_A/mission_A_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mission_controller.dart';

class MissionAPage extends GetView<MissionController> {
  const MissionAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Obx(()=> Text('오늘의 말씀 day${controller.day.value}')),
          ),
          body: Column(
            children: [
              Image.asset(
                'assets/bible_sample.png',
                width: Get.width*0.6,
              ),
              SizedBox(height: 20,),
              _buildBibleContainer(),
              SizedBox(height: 10,),
              Text('말씀을 터치해보세요',style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Obx(()=>
                ElevatedButton(
                    onPressed: (){
                      Get.to(()=>MissionAComment());
                    },
                    child: controller.missionCompleted['A']!
                        ?Text('의견 구경하기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)
                        :Text('의견 남기기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffA0C6FF),
                    fixedSize: Size(Get.width*0.7,50)
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  _buildBibleContainer() {
    return Obx(()=>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children :['개역개정','새번역','NIV영어'].asMap().entries.map(
                        (element) => Container(
                      decoration: BoxDecoration(
                        color: controller.bibleIndex.value%3==element.key?Colors.indigo:Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(3),
                      child: GestureDetector(
                          onTap: (){
                            controller.bibleIndex(element.key);
                          },
                          child: Container(
                              child: Text(element.value,style: TextStyle(color: Colors.white),
                              )
                          )
                      ),
                    )
                ).toList()
            ),
            SizedBox(height: 10,),

            IndexedStack(
                index: controller.bibleIndex.value%3,
                children: ['개역개정','새번역','NIV영어'].map(
                        (element) {
                      return GestureDetector(
                        onTap: (){
                          controller.bibleIndex.value++;
                        },
                        child: Text(
                          controller.missionA[element],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                ).toList()
            ),
            SizedBox(height: 10,),
            Text(
              controller.missionA['성경']+' '+controller.missionA['장:절'],
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
