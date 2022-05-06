import 'package:bybloom_tree/pages/mission_page/pages/type_A/mission_A_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mission_controller.dart';

class MissionAPage extends GetView<MissionController> {
  const MissionAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/mission_background.png',
              width: Get.width,
              height: Get.height,
              fit: BoxFit.fill,

            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              appBar: AppBar(
                title: Text('오늘의 말씀',style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                centerTitle: false,
                titleSpacing: 0,
                actions: [
                  Obx(()=> Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          controller.missionA['성경']+' '+controller.missionA['장:절'],
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 20
                          ),
                        ),
                    ),
                  ),
                  ),
                ]
              ),
              body: Column(
                children: [
                  SizedBox(height: 20,),
                  _buildBibleContainer(),

                  Spacer(),
                  Obx(()=>
                    ElevatedButton(
                        onPressed: (){
                          Get.to(()=>MissionAComment());
                        },
                        child: controller.missionCompleted['A']!
                            ?Text('은혜 구경하기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)
                            :Text('은혜 남기기',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffA0C6FF),
                        fixedSize: Size(Get.width*0.7,50)
                      ),
                    ),
                  ),
                  SizedBox(height: 30,)
                ],
              ),
            ),
          ],
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(3),
                      child: GestureDetector(
                          onTap: (){
                            controller.bibleIndex(element.key);
                          },
                          child: Text(
                              element.value,
                              style: controller.bibleIndex.value%3==element.key
                                  ?TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)
                                  :TextStyle(color: Colors.grey.shade200.withOpacity(0.5),fontWeight: FontWeight.normal,fontSize: 18)
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
                            fontSize: 21,
                            height: 1.4
                          ),
                        ),
                      );
                    }
                ).toList()
            ),
            SizedBox(height: 10,),

            Align(alignment: Alignment.center,child: Text('말씀을 터치해보세요',style: TextStyle(color: Colors.grey, fontSize: 18.5),)),
          ],
        ),
      ),
    );
  }
}
