import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendProfileController extends GetxController with GetTickerProviderStateMixin {
  /// 애니메이션 관련 참조
  late AnimationController wateringController;
  late Animation<double> wateringAnimation;

  late AnimationController containerController;
  late Animation<Offset> containerAnimation;
  /// ------------------------------------------------------

  Rx<bool> watered = false.obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    wateringController = AnimationController(vsync: this,duration: Duration(milliseconds: 2500));
    wateringAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(wateringController);
    containerController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
    ..repeat(reverse: true);
    containerAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0,-0.1)
    ).animate(containerController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    wateringController.dispose();
    containerController.dispose();
    super.dispose();
  }
}