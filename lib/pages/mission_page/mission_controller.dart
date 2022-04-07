import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../tree_page/tree_controller.dart';


/// 그냥 각 미션 별로 체크 박스만 만들어놓음.
/// db 연결하면서 미션 목록 불러오고, 완료 여부 확인도 할 수 있도록 해야할 듯.
class MissionController extends GetxController {

  BottomDrawerController controller=BottomDrawerController();
  // 반응형 day -> Stream 과 bindStream
  Rx<int> day = 1.obs;
  /// 반응형 missions 가 담긴 변수들과 업데이트 메소드
  // 반응형 변수들
  RxMap<String,dynamic> missionA = RxMap<String,dynamic>({});
  RxMap<String,dynamic> missionB = RxMap<String,dynamic>({});

  CollectionReference missionsRef = FirebaseFirestore.instance.collection('missions');

  // 반응형 변수(데일리 미션 정보) 컨트롤 메소드
  void updateDailyMission(String type, int day) async {
    /// missionA 데이터 업데이트
    DocumentReference<Map<String,dynamic>> missionARef = missionsRef.doc('day$day').collection('category').doc(type);
    DocumentSnapshot<Map<String,dynamic>> data = await missionARef.get();
    switch(type) {
      case 'A':
        missionA.addAll(data.data()!);
        break;
      case 'B':
        missionB.addAll(data.data()!);
        break;
    }
  }


  RxMap<String,bool> missionCompleted = <String,bool>{
    'A':false,
    'B':false,
    'C':false,
    'D':false
  }.obs;



  /// 미션 A 댓글창 컨트롤러
  late TextEditingController commentControllerA;
  /// 미션 B 댓글창 컨트롤러
  late TextEditingController commentControllerB;

  /// 댓글 조작 메서드 모음 --------------------------------------------------------------------------
  void uploadComment({required String comment, required String type}){
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').add({
      'writer': Get.find<TreeController>().currentUserModel!.name,
      'contents':comment,
      'createdAt':DateTime.now(),
      'uid':Get.find<TreeController>().currentUserModel!.uid,
      'like':[]
    });
  }
  void plusLikeCount({required String docId, required String type}) {
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).update({
      'like':FieldValue.arrayUnion([Get.find<TreeController>().currentUserModel!.uid])
    });
  }

  void minusLikeCount({required String docId, required String type}) {
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).update({
      'like':FieldValue.arrayRemove([Get.find<TreeController>().currentUserModel!.uid])
    });
  }

  void deleteComment({required String docId, required String type}) {
    // comment 컬렉션에서 삭제
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).delete();
    // mission_completed 컬렉션에서 삭제
    var doc = FirebaseFirestore.instance.collection('users').doc(Get.find<TreeController>().currentUserModel!.uid).collection('mission_completed').doc('day${day.value}');
    doc.update({
      type:FieldValue.delete()
    });

  }

  void updateComplete({required String comment, required String type}) async{
    var doc = FirebaseFirestore.instance.collection('users').doc(Get.find<TreeController>().currentUserModel!.uid).collection('mission_completed').doc('day${day.value}');
    var dayRef = await doc.get();
    if (dayRef.exists){
      doc.update({
        type:{
          'contents':comment,
          'createdAt':DateTime.now()
        }
      });
    } else {
      doc.set({
        type:{
          'contents':comment,
          'createdAt':DateTime.now()
        }
      });
    }
  }
  /// -------------------------------------------------------------------------  댓글 조작 메서드 모음


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    commentControllerA = TextEditingController();
    commentControllerB = TextEditingController();
    // day 값 스트림에 연결
    day.bindStream(missionsRef.doc('today').snapshots().map((event) => event.get('day')));
    // day 가 변경 시마다 데이터 업데이트
    ever(day, (day) async {
      /// missionA 데이터 업데이트
      updateDailyMission('A', day as int);
      /// missionB 데이터 업데이트
      updateDailyMission('B', day);

      /// missionCompleted 데이터 업데이트
      try {
        missionCompletedUpdate();
      } catch(e) {
        Future.delayed(Duration(milliseconds: 500)).then((value) => missionCompletedUpdate());
      }
    });



  }

  void incrementExp(int num) {
    FirebaseFirestore.instance.collection('users').doc(Get.find<TreeController>().currentUserModel!.uid).update({
      'exp':FieldValue.increment(num)
    });
  }

  void missionCompletedUpdate(){
    bool A = false;
    bool B = false;
    bool C = false;
    bool D = false;
    DocumentReference dayCompleted = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('mission_completed').doc('day$day');
    missionCompleted.bindStream(dayCompleted.snapshots().map((event){
      // 스냅샷 존재하지 않을 경우
      if (!event.exists){
        return {
          'A':A,
          'B':B,
          'C':C,
          'D':D,
        };
      }
      Map<String,dynamic> data = event.data() as Map<String,dynamic>;
      if (data.containsKey('A')){
        A = true;
      } else {
        A = false;
      }
      if (data.containsKey('B')){
        B = true;
      } else {
        B = false;
      }
      if (data.containsKey('C')){
        C = true;
      } else {
        C = false;
      }
      if (data.containsKey('D')){
        D = true;
      } {
        D = false;
      }
      return {
        'A':A,
        'B':B,
        'C':C,
        'D':D,
      };
    }));
  }

  // 미션 내부 변수
  Rx<bool> opened = false.obs;
  Rx<int> bibleIndex = 0.obs;




  Map typeMatch = {
    'A':'오늘의 말씀',
    'B':'나눔미션',
    'C':'감사일기',
    'D':'교회 연계미션'
  };

  /// MissionB 내부 변수
  Rx<int> selectedContainer = 0.obs;




}