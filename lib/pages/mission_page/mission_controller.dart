import 'package:get/get.dart';
class MissionController {
  var missionList = ['금요예배 드리기','기도 5분 하기','오늘 말씀 확인하기'].obs;

  RxList<bool> missionComplete = [false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }
}