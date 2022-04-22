import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
enum Sex {man, woman, yet}

/// DB 제어는 이 컨트롤러를 통해서 하는게 좋을 것 같음
/// 파일 구조의 깔끔함을 위해서 DB 제어 전용 파일을 하나 더 만들어도 좋고
/// 어쨌든 get 의 정신을 살려서 page 파일에는 내부 로직 코드가 나오지 않도록!
class SignupController extends GetxController{


  // --------------------------------------------------------
  /// 1. SignupPageBasicInformation
  /// 이름, 생년월일, 성별 - 인적사항
  // form 제어용 global key
  GlobalKey<FormState> pageBasicKey = GlobalKey();
  final FocusNode pageBasicFocusNode1 = FocusNode();

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
  // ---------------------------------------------------------
  /// 2. SignupPageChurch
  /// 교회 참여 정도 조사
  /// 교회 조사

  Rx<double> sliderValue = 20.0.obs;
  TextEditingController churchCon = TextEditingController();
  GlobalKey<FormState> pageChurchKey = GlobalKey();

  // --------------------------------------------------------
  /// 3. SignupPageProfile
  /// 닉네임과 프로필
  // form 제어용 global key
  GlobalKey<FormState> pageNicknameKey = GlobalKey();
  final FocusNode pageNicknameFocusNode1 = FocusNode();
  Rx<int> selectedProfile = 0.obs;
  List<String> profileList = ['a_1','a_2','f_1','f_2','f_3','f_4','m_1','m_2','m_3'];

  // 닉네임 제어
  Rx<String> imageurl=''.obs;
  TextEditingController nicknameCon = TextEditingController();

  // --------------------------------------------------------
  /// 4. SignupPagePhone
  /// 전화번호 인증
  // form 제어용 global key
  GlobalKey<FormState> page3Key = GlobalKey();
  final FocusNode page3FocusNode1 = FocusNode();
  final FocusNode page3FocusNode2 = FocusNode();

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
    pageBasicFocusNode1.dispose();
    page3FocusNode1.dispose();
    pageNicknameFocusNode1.dispose();
    nameCon.dispose();
    birthCon.dispose();
    phoneCon.dispose();
    smsCon.dispose();
    nicknameCon.dispose();
    churchCon.dispose();
    super.onClose();
  }
}