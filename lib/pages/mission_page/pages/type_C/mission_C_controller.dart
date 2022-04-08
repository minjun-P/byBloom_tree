import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MissionCController extends GetxController {
  late TextEditingController textEditingController;
  @override
  void onInit() {
    // TODO: implement onInit
    textEditingController = TextEditingController();
    super.onInit();
  }
  void uploadMissionC(String text) async{
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(DbController.to.currentUserModel.uid);
    DocumentReference dayDoc = userDoc.collection('mission_completed').doc('day${Get.find<MissionController>().day.value}');
    var dayRef = await dayDoc.get();
    if (dayRef.exists){
      dayDoc.update({
        'C': {
          'contents':text,
          'createdAt':DateTime.now()
        }
      });
    } else {
      dayDoc.set({
        'C': {
          'contents':text,
          'createdAt':DateTime.now()
        }
      });
    }

  }
}