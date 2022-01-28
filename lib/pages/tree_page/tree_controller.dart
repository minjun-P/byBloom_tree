import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TreeController extends GetxController with GetTickerProviderStateMixin{

  late AnimationController wateringIconController;
  late AnimationController rainController;
  late Animation<double> rainAnimation;

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

  void animateWateringIcon() async {
    await wateringIconController.forward();
    await wateringIconController.reverse();
    await rainController.forward();
    await rainController.reverse();
  }
}