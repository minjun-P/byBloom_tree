import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../components/signup_gauge.dart';
import 'signup_page4.dart';

/// 전화번호
class SignupPage3 extends GetView<SignupController> {
  const SignupPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 0.5초 뒤 키보드 뜨게 하기
    Future.delayed(const Duration(milliseconds: 500),()=>controller.page3FocusNode1.requestFocus());
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              child: const  Text('넘어가기',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
              onPressed: (){
                if (controller.page3Key.currentState!.validate()){
                  Get.to(()=>SignupPage4(),transition: Transition.rightToLeftWithFade);
                }

              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  side: BorderSide(color: Colors.grey,width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupGauge(minusWidth: 120),
              SizedBox(height: 30,),
              Text('더 자세히 알려주세요!',style: TextStyle(color: Colors.black,fontSize: 20),),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: controller.page3Key,
                      child: SignupTextField(
                        focusNode: controller.page3FocusNode1,
                        textController: controller.phoneCon,
                        keyboardType: TextInputType.phone,

                        labelText: '전화번호',
                        hintText: '01012345678',
                        helperText: '\'-\' 없이 숫자로만 쭉 입력해주세요',
                        validator: (value) {
                          if (value!.isEmpty){
                            return '올바른 전화번호 값을 입력하세요';
                          }
                          if (value.length !=11) {
                            return '번호가 8자리가 아닙니다';
                          }
                          else {
                            return null;
                          }
                        },

                        // 애초에 숫자만 입력되도록
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      )
                    ),
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