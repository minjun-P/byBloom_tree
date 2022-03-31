import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tutorial.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 메인 컨트롤러
/// 1. 네비게이션 바, 메인스크린 컨트롤
/// 2. 종료 시 팝업 제어
/// 3. 튜토리얼 제어
/// 4. 토큰 데이터베이스에 저장하기
class MainController extends GetxController{
  String? _token;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  // 다큐먼트 스냅샷
  Stream<DocumentSnapshot> documentStream= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();


  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    // 기기의 토큰을 받아오기
    _token = await FirebaseMessaging.instance.getToken();
    // 맨 아래 정의한 메소드 통해서 받아온 토큰을 데이터베이스에 저장하기
    await saveTokenToDatabase(_token!);
    // 토큰이 리프레시 될 때 자동으로 데이터베이스에 토큰 저장하는 메소드 사용
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

  }



  /// 네비게이션 바 컨트롤 변수
  var navigationBarIndex = 0.obs;
  /// 네비게이션 바 컨트롤 메소드
  void changeNavigationBarIndex (int index) {
    navigationBarIndex(index);
 }

  /// WillPopScope 적용 - 메인스크린에서 뒤로가기 버튼 제어

  Future<bool> showExitPopup(context) async {
    return await AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        title: '종료하시겠어요?',
        desc: '저희는 당신의 신앙 도우미 bybloom이었습니다. 다음에 또 놀러오세요!',
        body: FractionallySizedBox(
          widthFactor: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('종료하시겠어요?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Text('저희는 당신의 신앙 도우미 bybloom 이었습니다. 다음에 또 놀러오세요!')
            ],
          ),
        ),
        btnOkText: '아니오',
        btnOkOnPress: () {
          Get.back(closeOverlays: true);
        },
        btnCancelText: '네',
        btnCancelOnPress: () {
          exit(0);
        }
    ).show();
  }

  /// 튜토리얼 객체 tutorial에 context를 받아 실행시키는 메소드
  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(
        Get.overlayContext!,
        targets: targets,
        colorShadow: Colors.grey,
        opacityShadow: 0.3,
        alignSkip: Alignment.center,
        focusAnimationDuration: const Duration(milliseconds: 500),
        onClickTarget: (target){
          if(target.identify == '4'){
            changeNavigationBarIndex(1);
          }
          if(target.identify == '5'){
            changeNavigationBarIndex(2);
          }
          if(target.identify == '6'){
            changeNavigationBarIndex(3);
          }
        },
        onFinish: (){
          changeNavigationBarIndex(0);
          AwesomeDialog(
              context: Get.overlayContext!,
              dialogType: DialogType.SUCCES,
              title: '튜토리얼 끝! 수고하셨어요!',
              desc: '그럼 한번 첫 미션을 수행해볼까요??',
              btnOkOnPress: (){
                changeNavigationBarIndex(1);
              },
              btnOkText: '네 좋아요!'
          ).show();
        },
    );
    tutorial.show();
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }


  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
  /// 누군가에게 푸시알림 보내기
  Future<void> sendFcm({required String token, required String title, required String body}) async {
    HttpsCallable callable = functions.httpsCallable('sendFCM');
    final resp = await callable.call(<String, dynamic> {
      'token': token,
      'title': title,
      'body': body
    });
    //print(resp.data);
  }



}