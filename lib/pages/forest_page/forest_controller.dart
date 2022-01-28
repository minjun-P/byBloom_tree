import 'package:get/get.dart';

class ForestController extends GetxController {
  var complete = false.obs;
  void updateMissionComplete(){
    complete(!complete.value);
  }
}