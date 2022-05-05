import 'package:bybloom_tree/DBcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TreeController extends GetxController with GetTickerProviderStateMixin{


  Rx<bool> rain = false.obs;
  // 간단하게 하기 위해 getter from DbController 에 있는 currentUserModel
  int get exp => DbController.to.currentUserModel.value.exp;
  int get level => DbController.to.currentUserModel.value.level;
  Rx<int> waterToLimit = 0.obs;


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
  Future<void> onInit()  async {
    // TODO: implement onInit
    super.onInit();
    /// 레벨업 애니메이션
    levelUpAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 5000)
    );
    levelUpAnimation = Tween<double>(
        begin: 0,
        end: 1
    ).animate(levelUpAnimationController);
    /// 물주기 애니메이션
    wateringController = AnimationController(vsync: this,duration: const Duration(milliseconds: 2500));
    wateringAnimation = Tween<double>(
        begin: 0,
        end: 1
    ).animate(wateringController);
    await FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: 'Tree'
    );
  }



  void levelUp(int currentLevel){
    DocumentReference doc =FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    doc.update({
      'exp':FieldValue.increment(-expStructure[(currentLevel).toString()]),
      'level':FieldValue.increment(1)
    });
    FirebaseAnalytics.instance.logEvent(
        name: 'levelup',
      parameters: {'level':currentLevel+1}
    );
  }


  /// 알림보내기
  var title = ''.obs;
  var body = ''.obs;

  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  Future<void> sendFcm({required String token, required String title, required String body}) async {
    HttpsCallable callable = functions.httpsCallable('sendFCM');
    await callable.call(<String, dynamic> {
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
    '6':60,
    '7':60,
    '8':1000
  };


}