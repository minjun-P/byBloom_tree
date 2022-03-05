import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission_types/type_qt.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission_types/type_survey_b.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'mission_types/type_survey_a.dart';

class MissionExecutePage extends StatefulWidget {
  final Mission mission;
  const MissionExecutePage({
    key,
    required this.mission
  }) : super(key: key);

  @override
  _MissionExecutePageState createState() => _MissionExecutePageState();
}

class _MissionExecutePageState extends State<MissionExecutePage> {
  late PanelController controller;
  bool opened = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PanelController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: !opened&&widget.mission.type!=MissionType.surveyB?Container(
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
        body: SlidingUpPanel(
          controller: controller,
          // panel open 시, 뒷 화면 검은색
          backdropEnabled: true,
          // panel 세팅
          defaultPanelState: PanelState.OPEN,
          slideDirection: SlideDirection.DOWN,
          minHeight: 200,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft:  Radius.circular(20)),
          // open, close 시 변수 변경 및 rebuild
          onPanelOpened: (){
            setState(() {
              opened = true;
            });
          },
          onPanelClosed: (){
            setState(() {
              opened = false;
            });
          },
          // 실제 panel 영역에 들어갈 위젯
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/bible_sample.png',
                width: 200,
              ),
              const Spacer(),
              // 미션 제목 ex) '오늘의 질문'
              Text(widget.mission.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              // 미션 질문
              Container(
                width:Get.width,
                height: 200,
                alignment: Alignment.center,
                // 디테일 - 타입 따라 질문 디자인 스타일 다르게
                child: widget.mission.type==MissionType.qt
                ?Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.mission.contents!['from']),
                    SizedBox(height: 10,),
                    Text(
                      '" ${widget.mission.question} "',
                      style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),


                  ],
                )
                :Text(
                  widget.mission.question,
                  style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
                ),
              ),
              // 밑에 잔바리, for UX
              Visibility(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        const Text('위로 밀어올리기',style: TextStyle(color: Colors.grey,fontSize: 14),),
                        Positioned(
                          bottom: -50,
                          child: IconButton(
                            icon:const Icon(Icons.arrow_upward,size: 50,),
                            onPressed: (){
                              controller.close();
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
                visible: opened,
              )
            ],
          ),
          body: Builder(
            builder: (BuildContext context) {
              switch (widget.mission.type) {
                case MissionType.surveyB:
                  return SurveyB(choices: widget.mission.contents!['choices'],);
                case MissionType.surveyA:
                  return SurveyA();
                case MissionType.qt:
                  return Qt();
              }
            }
          ),
        ),
      ),
    );
  }
}
