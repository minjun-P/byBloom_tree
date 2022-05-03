import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';

class LoginController extends GetxController{

  GlobalKey<FormState> loginpageKey1 = GlobalKey();
  GlobalKey<FormState> loginpageKey2 = GlobalKey();
  final FocusNode loginpageFocusNode1 = FocusNode();
  final FocusNode loginpageFocusNode2 = FocusNode();

  // 전화번호 제어
  TextEditingController phoneCon = TextEditingController();
  TextEditingController smsCon = TextEditingController();
  //전화번호로그인제어
  Rx<bool> phonesuc=false.obs;

  // 폰인증 타이머
  CountdownController countdownController = CountdownController();
  Rx<bool> countdown = false.obs;

  @override
  void onClose() {
    // TODO: implement onClose

    loginpageFocusNode1.dispose();
    phoneCon.dispose();
    smsCon.dispose();
    super.onClose();
  }
}