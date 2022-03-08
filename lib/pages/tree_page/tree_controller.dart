import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Tree 페이지의 컨트롤러
/// - 경험치 제어
/// - 나무 성장단계 제어
/// - 물받기 제어
/// 이러한 기능이 필요할 듯 하다.
class TreeController extends GetxController with GetTickerProviderStateMixin{

  late AnimationController wateringIconController;
  late AnimationController rainController;
  late Animation<double> rainAnimation;

  final List<Image> imageList = [
    Image.asset('assets/tree/background_1.jpg',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_1.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_2.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_3.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_4.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_5.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_6.png',width: Get.width,fit: BoxFit.fitWidth,),
  ];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    wateringIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 0.05
    );
    rainController = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    rainAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(rainController);

  }

  @override
  void didChangeDependencies(BuildContext context) {
    // TODO: implement didChangeDependencies
    for (int i=1;i<=6;i++) {
      precacheImage(imageList[i].image, Get.context!);
    }
    super.didChangeDependencies(context);
  }

  void animateWateringIcon() async {
    await wateringIconController.forward();
    await wateringIconController.reverse();
    await rainController.forward();
    await rainController.reverse();
  }

  Rx<int> treeGrade = 1.obs;
  void treeUpgrade() {
    if (treeGrade.value == 6) {
      treeGrade(1);
    } else {
      treeGrade(treeGrade.value+1);
    }
  }

}