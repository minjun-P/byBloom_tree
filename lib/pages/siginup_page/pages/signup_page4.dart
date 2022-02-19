import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/signup_gauge.dart';
import 'signup_page5.dart';

/// 닉네임, 프로필 사진
class SignupPage4 extends GetView<SignupController> {
  const SignupPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 600),()=>controller.page4FocusNode1.requestFocus());
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              child: const Text('이제 마지막!',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
              onPressed: (){
                if (controller.page4Key.currentState!.validate()){
                  // 키보드 포커스 없애기
                  FocusManager.instance.primaryFocus!.unfocus();
                  Get.to(()=>const SignupPage5(),transition: Transition.rightToLeftWithFade);
                }

              },
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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SignupGauge(minusWidth: 80,),
              const SizedBox(height: 20,),
              const Text('프로필을 설정해 보아요!',style: TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  // 특이하게 reverse 를 true로 해놓음. 이렇게 해야 키보드가 올라올 때 textfield가 안 짤려서 UX가 좋다.
                  reverse: true,
                  children: [
                    const SizedBox(height: 80,),
                    Form(
                      key: controller.page4Key,
                      child: SignupTextField(
                        focusNode: controller.page4FocusNode1,
                        textController: controller.nicknameCon,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '값을 입력하세요';
                          } else {
                            return null;
                          }
                        },
                        labelText: '닉네임',
                        hintText: '남들에게 보여질 별명을 정해주세요',
                      )
                    ),
                    const SizedBox(height: 20,),
                    Center(
                      child: TextButton(
                        child: const Text('프로필 설정하기'),
                        onPressed: (){
                          /// 요청 : 사진 업로드 하는 로직 넣어줘용
                        },
                      ),
                    ),
                    const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.lightGreenAccent,
                        radius: 100,
                      ),
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