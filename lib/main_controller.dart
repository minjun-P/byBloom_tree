import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController {

  // 네비게이션 바 컨트롤 ------
  var navigationBarIndex = 0.obs;
  void changeNavigationBarIndex (int index) {
    navigationBarIndex(index);
 }
 // 네비게이션 바 컨트롤 ------
}