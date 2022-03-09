import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../signup_controller.dart';
import '../components/signup_gauge.dart';
import '../components/signup_textfield.dart';
import 'signup_page3.dart';

// GetView 는 Stateles s를 상속한 get 패키지의 특수 객체야. 제너릭 안에 써준 컨트롤러 클래스 타입을 그냥 controller 변수에 알아서 저장을 해줘서 편하게 쓸 수 있어.
/// 이름, 성별, 생년월일
class SignupPage2 extends GetView<SignupController> {
  const SignupPage2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 0.5초 뒤에 첫번째 textfield 알아서 클릭해주기 -> 그럼 알아서 키보드가 뜨겠지?
    Future.delayed(const Duration(milliseconds: 500),()=>controller.page2FocusNode1.requestFocus());

    return SafeArea(
      child: Scaffold(
        // bottomSheet은 위에서 올라오는 키보드 위에 알아서 위치를 차지하는 위젯을 지정하는 파라미터임.
        // 여기에 넘어가기 버튼을 넣어놨어.
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          alignment: Alignment.center,
          child: OutlinedButton(
            child: const Text('넘어가기',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
            onPressed: (){
              /// 유효성 검사 실행 - false이면 알아서 빨간색으로 바뀜.
              // 1. 성별 체크박스 유효성 검사
              controller.validateSex();
              // 2. 글로벌키(page2Key) 통해서 validate 내장 메소드 활용
              controller.page2Key.currentState!.validate();
              // 유효성 검사 값이 모두 true일 경우,
              if (controller.validateSex()&&controller.page2Key.currentState!.validate()){
                Get.to(()=>SignupPage3(),transition: Transition.rightToLeftWithFade);
                }
              },
            // 버튼 스타일 설정
            style: OutlinedButton.styleFrom(
                primary: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                side: const BorderSide(color: Colors.grey,width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // components/signup_gauge 파일에 있음. 상단 게이지 - hero 애니메이션 활용
              const SignupGauge(minusWidth: 200),
              const SizedBox(height: 30,),
              const Text('당신은 누구인가요?',style: TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  // 혹시 어떤 환경에서는 overflow error가 발생할 수 있으므로,
                  // 텍스트폼 필드를 Listview안에 넣어놨음.
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Form(
                            key: controller.page2Key,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 위젯을 따로 만들었음. 파일 참고
                                SignupTextField(
                                    focusNode: controller.page2FocusNode1,
                                    textController: controller.nameCon,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if(value!.isEmpty) {
                                        return '값을 입력하세요';
                                      } else {
                                        return null;
                                      }
                                    },
                                    labelText: '이름',
                                ),
                                const SizedBox(height: 10,),
                                SignupTextField(
                                  textController: controller.birthCon,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return '값을 입력하세요';
                                    }
                                    if (!value.isNum) {
                                      return '숫자가 아닙니다';
                                    }
                                    if(int.parse(value)<19000000 || int.parse(value)>20500000){
                                      return '8자리로 입력해주세요.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: 'YYYYMMDD',
                                  labelText: '생년월일',
                                  helperText: 'ex) 19820708',
                                )

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 30,),
                        Obx(()=>Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '남성',
                                    style: TextStyle(
                                        color: controller.validateOk.value?Colors.black:Colors.red,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Radio<Sex>(
                                    value: controller.man,
                                    groupValue: controller.userSex.value,
                                    onChanged: (Sex? value){
                                      controller.userSex(value);
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '여성',
                                    style: TextStyle(
                                        color: controller.validateOk.value?Colors.black:Colors.red,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Radio<Sex>(
                                    value: controller.woman,
                                    groupValue: controller.userSex.value,
                                    onChanged: (Sex? value){
                                      controller.userSex(value);
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}