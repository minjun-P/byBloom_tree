import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum Sex {man, woman, yet}

/// DB 제어는 이 컨트롤러를 통해서 하는게 좋을 것 같음
/// 파일 구조의 깔끔함을 위해서 DB 제어 전용 파일을 하나 더 만들어도 좋고
/// 어쨌든 get 의 정신을 살려서 page 파일에는 내부 로직 코드가 나오지 않도록!
class SignupController extends GetxController{


  // --------------------------------------------------------
  /// SignupPage2
  // form 제어용 global key
  GlobalKey<FormState> page2Key = GlobalKey();
  final FocusNode page2FocusNode1 = FocusNode();

  // 이름 제어
  TextEditingController nameCon = TextEditingController();
  // 생년월일 제어
  TextEditingController birthCon = TextEditingController();
  // 성별 제어
  Sex man = Sex.man;
  Sex woman = Sex.woman;
  var userSex = Sex.yet.obs;
  var validateOk = true.obs;
  bool validateSex(){
    if (userSex.value == Sex.yet){
      validateOk(false);
    }
    else {
      validateOk(true);
    }
    return validateOk.value;
  }

  // --------------------------------------------------------
  /// SignupPage3
  // form 제어용 global key
  GlobalKey<FormState> page3Key = GlobalKey();
  final FocusNode page3FocusNode1 = FocusNode();

  // 전화번호 제어
  TextEditingController phoneCon = TextEditingController();

  // --------------------------------------------------------
  /// SignupPage4
  // form 제어용 global key
  GlobalKey<FormState> page4Key = GlobalKey();
  final FocusNode page4FocusNode1 = FocusNode();

  // 닉네임 제어
  TextEditingController nicknameCon = TextEditingController();

  // ---------------------------------------------------------
  /// SignupPage5
  Rx<bool> checked1 = false.obs;
  Rx<bool> checked2 = false.obs;
  Rx<bool> checked3 = false.obs;
  Rx<bool> checked4 = false.obs;
  Rx<bool> checked5 = false.obs;

  Rx<double> sliderValue = 20.0.obs;

  @override
  void onClose() {
    // TODO: implement onClose
    page2FocusNode1.dispose();
    page3FocusNode1.dispose();
    page4FocusNode1.dispose();
    nameCon.dispose();
    birthCon.dispose();
    phoneCon.dispose();
    nicknameCon.dispose();
    super.onClose();
  }
}