import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  GlobalKey<FormState> loginpageKey = GlobalKey();
  final FocusNode loginpageFocusNode1 = FocusNode();
  final FocusNode loginpageFocusNode2 = FocusNode();

  // 전화번호 제어
  TextEditingController phoneCon = TextEditingController();
  TextEditingController smsCon = TextEditingController();
  //전화번호로그인제어
  Rx<bool> phonesuc=false.obs;

  @override
  void onClose() {
    // TODO: implement onClose

    loginpageFocusNode1.dispose();
    phoneCon.dispose();
    smsCon.dispose();
    super.onClose();
  }
}