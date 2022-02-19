import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// 그냥 각 미션 별로 체크 박스만 만들어놓음.
/// db 연결하면서 미션 목록 불러오고, 완료 여부 확인도 할 수 있도록 해야할 듯.
class MissionController {
  var missionList = ['금요예배 드리기','기도 5분 하기','오늘 말씀 확인하기'].obs;

  RxList<bool> missionComplete = [false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }

  ScrollController scrollController = ScrollController();

  void moveScroll() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

}