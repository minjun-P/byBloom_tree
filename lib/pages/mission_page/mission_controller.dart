
import 'dart:math';

import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:bybloom_tree/pages/mission_page/mission_model.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../main_controller.dart';
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
  late TextEditingController reportControllerA;
  /// 미션 B 댓글창 컨트롤러
  late TextEditingController commentControllerB;
  late TextEditingController reportControllerB;

  /// 댓글 조작 메서드 모음 --------------------------------------------------------------------------
  // 해당 미션 Db 바로 아래 comments 콢렉션에 추가
  void uploadComment({required String comment, required String type, int? index, bool? check}) async{

    // B이고 객관식일 땐 like 빼고 index 추가
    DocumentSnapshot typeDoc = await missionsRef.doc('day${day.value}').collection('category').doc(type).get();

    if (type=='B'&& typeDoc.get('객관식')){
      missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').add({
        'contents':comment,
        'createdAt':DateTime.now(),
        'uid':DbController.to.currentUserModel.value.uid,
        'index':index
      });
      return ;
    }
    // A 이거나 B 주관식일 때
    // 익명 체크됐을 때
    if (check==true){
      missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').add({
        'writer': anonymous.elementAt(Random().nextInt(225)),
        'contents':comment,
        'createdAt':DateTime.now(),
        'uid':DbController.to.currentUserModel.value.uid,
        'like':[]
      });
      return;
    }

    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').add({
      'writer': DbController.to.currentUserModel.value.name,
      'contents':comment,
      'createdAt':DateTime.now(),
      'uid':DbController.to.currentUserModel.value.uid,
      'like':[]
    });
  }
  // 미션 A 전용 like 컨트롤 메서드
  void plusLikeCount({required String docId, required String type}) {
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).update({
      'like':FieldValue.arrayUnion([DbController.to.currentUserModel.value.uid])
    });
  }
  // 미션 A 전용 like 컨트롤 메서드
  void minusLikeCount({required String docId, required String type}) {
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).update({
      'like':FieldValue.arrayRemove([DbController.to.currentUserModel.value.uid])
    });
  }

  void deleteComment({required String docId, required String type}) {
    // comment 컬렉션에서 삭제
    missionsRef.doc('day${day.value}').collection('category').doc(type).collection('comments').doc(docId).delete();
    // mission_completed 컬렉션에서 삭제
    /**
    var doc = FirebaseFirestore.instance.collection('users').doc(DbController.to.currentUserModel.value.uid).collection('mission_completed').doc('day${day.value}');
    doc.update({
      type:FieldValue.delete()
    });
*/
  }
  // 미션 Db 아래가 아니라 나의 유저 데이터 아래에 저장
  void updateComplete({required String comment, required String type, String? prayerCategory}) async{
    var doc = FirebaseFirestore.instance.collection('users').doc(DbController.to.currentUserModel.value.uid).collection('mission_completed').doc('day${day.value}');
    var dayRef = await doc.get();
    // prayerCategory 넣어주면, 타입 D이면
    if (prayerCategory!=null){
      if (dayRef.exists){
        doc.update({
          type:{
            'contents':comment,
            'createdAt':DateTime.now(),
            'prayerCategory': prayerCategory
          }
        });
      } else {
        doc.set({
          type:{
            'contents':comment,
            'createdAt':DateTime.now(),
            'prayerCategory': prayerCategory
          }
        });
      }
      // prayerCategory 안 넣은 경우
    } else {
      if (dayRef.exists){
        doc.update({
          type:{
            'contents':comment,
            'createdAt':DateTime.now(),
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

  }

  // 신고 메서드
  void reportComment({required int day, required String type, required String reason,required String who, required commentId}){
    var doc = FirebaseFirestore.instance.collection('report').add({
      'day':day,
      'type':type,
      'reason':reason,
      'who': who,
      'commentId':commentId
    });
  }
  /// -------------------------------------------------------------------------  댓글 조작 메서드 모음


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    // 텍스트 컨트롤러 모음
    commentControllerA = TextEditingController();
    reportControllerA = TextEditingController();
    commentControllerB = TextEditingController();
    reportControllerB = TextEditingController();
    missionControllerD = TextEditingController();
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
    ever(missionCompleted,(com){
      print(com);
    });



  }

  void incrementExp(int num) {
    FirebaseFirestore.instance.collection('users').doc(DbController.to.currentUserModel.value.uid).update({
      'exp':FieldValue.increment(num)
    });
  }

  void clearMission() {
    Future.delayed(Duration(milliseconds: 300)).then((_)=>incrementExp(3));
    Get.snackbar('수고하셨어요', '미션을 완료해 경험치를 3 획득했습니다',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          child: Text('확인하러 가보기!'),
          onPressed: (){
            Get.to(()=>MainScreen());
            Future.delayed(Duration(milliseconds: 300)).then((value) => Get.find<MainController>().navigationBarIndex(0));

          },
        )
    );
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
      // 다큐먼트 스냅샷 존재하지 않을 경우
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
      } else{
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
    'B':'나눔 미션',
    'C':'감사일기',
    'D':'오늘의 예배'
  };
  // ---------------------------------------------------------------------------
  /// MissionB 내부 변수
  Rx<int> selectedContainer = 0.obs;
  Rx<bool> checkbox = false.obs;
  Future<double> getResultNum(int num, int day) async {
    CollectionReference commentsRef = missionsRef.doc('day$day').collection('category').doc('B').collection('comments');
    QuerySnapshot allResults = await commentsRef.get();
    int allNum = allResults.docs.length;

    // 해당하는 번호인 답변의 스냅샷을 가져옴.
    QuerySnapshot numResultRef = await commentsRef
        .where('index',isEqualTo: num).get();
    if (num == 0){
      return allNum.toDouble();
    }
    // 답변수가 0이면
    if (allNum==0){
      return 0;
    }

    return numResultRef.docs.length/allNum;
  }
  Future<String> getUserSelection() async{
    CollectionReference missionCompleted = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('mission_completed');
    var doc = await missionCompleted.doc('day${day.value}').get();
    Map map = doc as Map;
    return map['B']['contents'];
  }
  // ----------------------------------------------------------------------------

  /// MissionD 내부 변수
  List prayerCategory = ['현장 예배','온라인 예배','다시 보기'];
  Rx<int> prayerIndex = 0.obs;
  late TextEditingController missionControllerD;

}
