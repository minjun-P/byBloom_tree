import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/User.dart';

/// Tree 페이지의 컨트롤러
/// - 경험치 제어
/// - 나무 성장단계 제어
/// - 물받기 제어
/// 이러한 기능이 필요할 듯 하다.





class TreeController extends GetxController with GetTickerProviderStateMixin{


  Rx<bool> rain = false.obs;
  // 간단하게 하기 위해 getter from DbController 에 있는 currentUserModel
  int get exp => DbController.to.currentUserModel.value.exp;
  int get level => DbController.to.currentUserModel.value.level;

  // 임시로 만든거, 푸시알림 보내기 기능
  late GlobalKey<FormState> formKey;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<Map> userDetail() {
    Stream<DocumentSnapshot> documentStream = fireStore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    return documentStream.map((event) => {'exp':event.get('exp'),'level':event.get('level')});
  }

  /// 유저모델 관리

  /// 애니메이션 초기화 모음
  late AnimationController wateringController;
  late Animation<double> wateringAnimation;

  late AnimationController levelUpAnimationController;
  late Animation<double> levelUpAnimation;


  @override
  void onInit()  {
    // TODO: implement onInit
    super.onInit();
    /// 레벨업 애니메이션
    levelUpAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 5000)
    );
    levelUpAnimation = Tween<double>(
        begin: 0,
        end: 1
    ).animate(levelUpAnimationController);
    /// 물주기 애니메이션
    wateringController = AnimationController(vsync: this,duration: Duration(milliseconds: 2500));
    wateringAnimation = Tween<double>(
        begin: 0,
        end: 1
    ).animate(wateringController);

    formKey = GlobalKey();
  }



  void levelUp(){
    DocumentReference doc =FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    doc.update({
      'exp':FieldValue.increment(-expStructure[DbController.to.currentUserModel.value.level.toString()]),
      'level':FieldValue.increment(1)
    });
  }


  /// 알림보내기
  var title = ''.obs;
  var body = ''.obs;

  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  Future<void> sendFcm({required String token, required String title, required String body}) async {
    HttpsCallable callable = functions.httpsCallable('sendFCM');
    final resp = await callable.call(<String, dynamic> {
      'token': token,
      'title': title,
      'body': body
    });
  }
  Map expStructure = {
    '1':3,
    '2':12,
    '3':30,
    '4':45,
    '5':60,
    '6':60
  };

}