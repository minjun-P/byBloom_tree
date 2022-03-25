import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission_types/type_qt.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission_types/type_survey_b.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'mission_types/type_survey_a.dart';

class MissionExecutePage extends GetView<MissionController> {
  final Mission mission;
  const MissionExecutePage({
    key,
    required this.mission
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()=>
        Scaffold(
          bottomSheet: !controller.opened.value&&mission.type!=MissionType.surveyB
              ?Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,-0.7),
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 0.1
                  )
                ]
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                SizedBox(width:10),
                Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '랄라블라로 의견 남기기'
                      ),
                      maxLines: 2,
                    )
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: (){},
                )
              ],
            ),
          ):null,
          body: Obx(()=>
            SlidingUpPanel(
              controller: controller.panelController,
              // panel open 시, 뒷 화면 검은색
              // panel 세팅
              defaultPanelState: PanelState.OPEN,
              slideDirection: SlideDirection.DOWN,
              minHeight: 250,
              maxHeight: Get.height*0.75,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft:  Radius.circular(20)),
              // open, close 시 변수 변경 및 rebuild
              onPanelOpened: (){
                controller.opened(true);
              },
              onPanelClosed: (){
                controller.opened(false);
              },
              // 실제 panel 영역에 들어갈 위젯
              panel: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/bible_sample.png',
                        width: 130,
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mission.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          Obx(()=> Text(
                            'day ${controller.day.value}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          )
                          )
                        ],
                      )
                    ],
                  ),
                  Spacer(flex: 11,),
                  // 미션 제목 ex) '오늘의 질문'
                  // 미션 질문
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    height: 250,
                    // 디테일 - 타입 따라 질문 디자인 스타일 다르게
                    child: mission.type==MissionType.qt
                        ?Obx(()=>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children :['개역개정','새번역','NIV영어'].asMap().entries.map(
                                  (element) => Container(
                                    decoration: BoxDecoration(
                                      color: controller.bibleIndex.value%3==element.key?Colors.indigo:Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(3),
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
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.5,
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
                  ))
                  :Text(
                    mission.question,
                    style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
                  ),
                ),
                Visibility(child: Spacer(flex: 2,),visible: controller.opened.value,),
                // 밑에 잔바리, for UX
                Visibility(
                  visible: controller.opened.value,
                  child:
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              const Text(
                                '말씀을 터치하면 다른 번역이 나와요!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Positioned(
                                bottom: -90,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon:const Icon(MdiIcons.chevronUp,size: 50,color: Colors.grey,),
                                      onPressed: (){
                                        controller.panelController.close();
                                      },
                                    ),
                                    SizedBox(height: 10,),
                                    const Text('위로 밀어올리기',style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 20,)
                        ],
                      ),
                  ),
              ]
                ),

            body: Builder(
              builder: (BuildContext context) {
                switch (mission.type) {
                  case MissionType.surveyB:
                    return SurveyB(choices: mission.contents!['choices'],);
                  case MissionType.surveyA:
                    return SurveyA();
                  case MissionType.qt:
                    return Qt();
                }
              }
            ),
          ),
        ),
    ),
      ));
  }
}


