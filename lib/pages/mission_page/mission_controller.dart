import 'package:get/get.dart';
import 'package:flutter/material.dart';


enum MissionType {qt, surveyA, surveyB }

class Mission {
  String title;
  String question;
  MissionType type;
  Map? contents;
  Mission({required this.title, required this.question, required this.type, this.contents});
}

List<Mission> missionList = [
  Mission(
    title: '성경 미니 큐티',
    question: '무엇보다 열심으로 \n서로 사랑할찌니\n 사랑은 허다한 죄를 덮느니라',
    type: MissionType.qt,
    contents: {
      'from':'창세기 3:3'
    }
  ),
  Mission(
    title: '오늘의 질문',
    question: '가장 좋아하는\n찬양이 있으신가요?\n이유를 알려주세요.',
    type: MissionType.surveyA
  ),
  Mission(
    title: '오늘의 질문',
    question: '우리 교회의 \n가장 큰 장점을\n알려주세요.',
    type: MissionType.surveyA
  ),
  Mission(
    title: '바이블룸 앙케이트',
    question: '가장 좋아하는\n성경인물을\n골라주세요!',
    type: MissionType.surveyB,
    contents: {
      'choices':['모세','아브라함','사도바울','베드로']
    }
  )
];

/// 그냥 각 미션 별로 체크 박스만 만들어놓음.
/// db 연결하면서 미션 목록 불러오고, 완료 여부 확인도 할 수 있도록 해야할 듯.
class MissionController {

  RxList<bool> missionComplete = [false,false,false,false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }
}