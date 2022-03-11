import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tutorial.dart';
import 'dart:io';

class MainController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
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



}