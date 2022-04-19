import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_A/mission_A_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/tree_page/tree_page.dart';

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

  late GlobalKey tutorialKey1;
  late GlobalKey tutorialKey2;
  late GlobalKey tutorialKey3;
  late GlobalKey tutorialKey4;
  late GlobalKey tutorialKey5;
  late GlobalKey tutorialKey6;
  late GlobalKey tutorialKey7;


  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    // 튜토리얼 용 GlobalKey 들
    tutorialKey1 = GlobalKey(debugLabel:'tutorial 1');
    tutorialKey2 = GlobalKey(debugLabel:'tutorial 2');
    tutorialKey3 = GlobalKey(debugLabel:'tutorial 3');
    tutorialKey4 = GlobalKey(debugLabel:'tutorial 4');
    tutorialKey5 = GlobalKey(debugLabel:'tutorial 5');
    tutorialKey6 = GlobalKey(debugLabel:'tutorial 6');
    tutorialKey7 = GlobalKey(debugLabel:'tutorial 7');
    // 기기의 토큰을 받아오기
    _token = await FirebaseMessaging.instance.getToken();
    // 맨 아래 정의한 메소드 통해서 받아온 토큰을 데이터베이스에 저장하기
    await saveTokenToDatabase(_token!);
    // 토큰이 리프레시 될 때 자동으로 데이터베이스에 토큰 저장하는 메소드 사용
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
   await FirebaseAnalytics.instance.setCurrentScreen(screenName: "mainScreeen");
    await FirebaseAnalytics.instance.logScreenView(screenName: "mainScreen");
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    print("로그수신");

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
          if(target.identify == '6.5'){
            changeNavigationBarIndex(1);
          }
          if(target.identify == '7'){
            Get.to(()=>MissionAPage());
          }
        },
        onFinish: (){
          changeNavigationBarIndex(0);
          AwesomeDialog(
              context: Get.overlayContext!,
              dialogType: DialogType.SUCCES,
              title: '튜토리얼 끝! 수고하셨어요!',
              desc: '첫 미션을 수행해해주세요!!',
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



  /// 누군가에게 푸시알림 보내기
  Future<void> sendFcm({required String token, required String title, required String body}) async {
    FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
    HttpsCallable callable = functions.httpsCallable('sendFCM');
    final resp = await callable.call(<String, dynamic> {
      'token': token,
      'title': title,
      'body': body
    });
    //print(resp.data);
  }



}

List<TargetFocus> targets = [
  // 1. 하단 나무 아이콘 튜토리얼
  TargetFocus(
      identify: '1',
      keyTarget: Get.find<MainController>().tutorialKey1,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: [
              '나의 나무를 여기서 확인할 수 있어요',
              '아이콘을 클릭해보세요'
            ], left: true
            )
        )
      ]
  ),
  // 2. 상단 알림 아이콘 튜토리얼
  TargetFocus(
      identify: '2',
      keyTarget: Get.find<MainController>().tutorialKey2,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: buildAlert(messages: [
              '친구가 물을 주고 간 기록을 볼 수 있어요.'
            ], left: false)
        )
      ]
  ),
  // 3. 상단 친구 목록 튜토리얼
  TargetFocus(
      identify: '3',
      keyTarget: Get.find<MainController>().tutorialKey3,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: buildAlert(
                messages: [
                  '여기에선 친구 목록을 확인하고',
                  '친구에게 메세지를 보낼 수 있어요!'
                ], left: true)
        )
      ]
  ),
  // 4. 하단 미션목록 아이콘 튜토리얼
  TargetFocus(
      identify: '4',
      keyTarget: Get.find<MainController>().tutorialKey4,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여길 클릭해보세요'], left: true))
      ]
  ),
  TargetFocus(
      identify: '4.5',
      keyTarget: Get.find<MainController>().tutorialKey4,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
                messages: [
                  '이 화면에서는 일간 미션을 확인할 수 있어요',
                  '여기 있는 미션을 수행하면 나무가 자라요!'
                ], left: true
            )
        )
      ]
  ),
  // 5. 하단 숲 아이콘 튜토리얼
  TargetFocus(
      identify: '5',
      keyTarget: Get.find<MainController>().tutorialKey5,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여길 클릭해보세요'], left: false)
        )
      ]
  ),
  TargetFocus(
      identify: '5.5',
      keyTarget: Get.find<MainController>().tutorialKey5,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
                messages: [
                  '\'숲\' 화면이에요!',
                  '숲에서는 친구모임을 만들거나 개인 메세지를 보낼 수 있어요!'
                ], left: false)
        )
      ]
  ),
  // 6. 하단 저장소 아이콘 튜토리얼
  TargetFocus(
      identify: '6',
      keyTarget: Get.find<MainController>().tutorialKey6,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여기를 클릭해보세요!'], left: false)
        ),
      ]
  ),
  TargetFocus(
      identify: '6.5',
      keyTarget: Get.find<MainController>().tutorialKey6,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
                messages: [
                  '이 곳은 \'프로필 화면\'입니다',
                  '미션 완료 기록과 작성한 감사일기를 ',
                  '확인할 수 잇어요'
                ],
                left: false
            )
        ),
      ]
  ),
  TargetFocus(
    identify:  '7',
    shape: ShapeLightFocus.RRect,
    keyTarget: Get.find<MainController>().tutorialKey7,
    contents: [
      TargetContent(
        padding: EdgeInsets.zero,
        align: ContentAlign.top,
        child: buildAlert(
          messages: [
            '첫 미션을 수행해봐요!'
          ],
          left: true
        )
      )
    ]
  )
];

Widget buildAlert({required List<String> messages,required bool left}) {
  return Column(
    crossAxisAlignment: left?CrossAxisAlignment.start:CrossAxisAlignment.end,
    children: messages.map((element) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(element),
      );
    }).toList(),
  );
}