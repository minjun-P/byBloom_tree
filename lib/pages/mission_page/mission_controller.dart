import 'package:get/get.dart';
import 'package:flutter/material.dart';
class MissionController {
  var missionList = ['금요예배 드리기','기도 5분 하기','오늘 말씀 확인하기'].obs;

  RxList<bool> missionComplete = [false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }

  ScrollController scrollController = ScrollController();

  void moveScroll() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 700), curve: Curves.ease);
  }

}