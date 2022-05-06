import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendProfileController extends GetxController with GetTickerProviderStateMixin {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// 애니메이션 관련 참조
  late AnimationController wateringController;
  late Animation<double> wateringAnimation;

  late AnimationController containerController;
  late Animation<Offset> containerAnimation;
  /// ------------------------------------------------------

  RxList waterTo = [].obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    wateringController = AnimationController(vsync: this,duration: const Duration(milliseconds: 2500));
    wateringAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(wateringController);
    containerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
    ..repeat(reverse: true);
    containerAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0,-0.1)
    ).animate(containerController);
    waterTo.bindStream(getStream());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    wateringController.dispose();
    containerController.dispose();
    super.onClose();
  }

  /// 물 주기 기록 디비에 반영하기
  void saveWateringRecord(String friendUid,String friendName) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // 내 디비에 누구한테 줬는지 저장
    DocumentReference doc = fireStore.collection('users').doc(uid).collection('waterTo').doc('day${Get.find<MissionController>().day.value}');
    DocumentSnapshot docRef =await  doc.get();
    if (docRef.exists){
      doc.update({
        'list':FieldValue.arrayUnion([friendUid])
      });
    } else {
      doc.set({
        'list':[friendUid]
      });
    }
    // 상대 디비에 내가 물 준 기록 저장
    fireStore.collection('users').doc(friendUid).update({
      'waterFrom':FieldValue.arrayUnion([{'who':uid,'when':DateTime.now(),'name':DbController.to.currentUserModel.value.name}])
    });
  }

  Stream<List> getStream() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> wateringStream = fireStore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('waterTo')
        .doc('day${Get.find<MissionController>().day.value}').snapshots();
    Stream<List> listStream = wateringStream.map((event){
      if (!event.exists){
        return [];
      }
      Map<String, dynamic> data = event.data() as Map<String, dynamic>;
      if (data.isEmpty){
        return [];
      } else {
        List list = data['list'] as List;
        return list;
      }
    });
    return listStream;
  }

  /**
  Future<bool> checkWatering(String friendUid) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // my 정보 document 가져오기
    DocumentSnapshot snapshot = await fireStore.collection('users').doc(uid).get();
    // map 으로 형태변환
    Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;
    // waterTo array 가져오기
    List<Map> waterToList = data['waterTo']??[];
    if (waterToList.isNotEmpty){
      waterToList.forEach((element) {

        Timestamp timestamp = element['when'] as Timestamp;
        // 각 리스트 내의 map의 날짜.
        DateTime date = timestamp.toDate();
        if (isSameDay(date,DateTime.now()) && element['who']==FirebaseAuth.instance.currentUser!.uid){

        } else {
          return true;
        }
      });
    } else{
      return false;
    }
  }
      */
}