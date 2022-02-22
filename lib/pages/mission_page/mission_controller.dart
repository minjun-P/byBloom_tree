import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'pages/mission1.dart';
import 'pages/mission2.dart';
import 'pages/mission3.dart';


class Mission<T> {
  String title;
  Widget Function() route;
  bool complete;
  String desc;
  Mission({required this.title,required this.route, required this.complete, required this.desc});
}

/// 그냥 각 미션 별로 체크 박스만 만들어놓음.
/// db 연결하면서 미션 목록 불러오고, 완료 여부 확인도 할 수 있도록 해야할 듯.
class MissionController {
  var mission1 = Mission<Mission1>(
    title: '미션1 - 묵상',
    route: ()=>Mission1(),
    complete: false,
    desc: '주어진 말씀을 같이 읽어보고 간단히 QT를 해봐요.'
  ).obs;
  var mission2 = Mission<Mission2>(
      title: '미션2 - 앙케이트',
      route: ()=>Mission2(),
      complete: false,
      desc: '바이블룸 앙케이트! 매일 다른 질문이 주어져요. ~~쏼라쏼라라라라랄'
  ).obs;
  var mission3 = Mission<Mission3>(
      title: '미션3 - 교회연계',
      route: ()=>Mission3(),
      complete: false,
      desc: '이번 주, 시민의 교회 담임목사님께서 직접 내신 미션입니다. ~~ 쏼라라라라라랄'
  ).obs;

  RxList<bool> missionComplete = [false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }


}