import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bybloom_tree/auth/authservice.dart';

/// 입력 결과값 확인하기 위해 만든 임시 페이지
CollectionReference users = FirebaseFirestore.instance.collection('users');
class SignupPage6 extends GetView<SignupController> {
  const SignupPage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text('bybloom',style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
              const Text('입력 결과 표시'),
              /// 아래를 쭉 보면, 입력했던 값들을 다 controller를 통해 제어하고 있음.
              /// controller로 일원화시켜놨다고 보면 됨. DB는 controller 통해서 제어하는 것으로
              Text('1.이름 : ${controller.nameCon.text}'),
              Text('2.생년월일 : ${controller.birthCon.text}'),
              Text('3. 성별 : ${controller.userSex.value==Sex.man?'남성':'여성'}'),
              Text('4. 전화번호 : ${controller.phoneCon.text}'),
              Text('5. 별명 : ${controller.nicknameCon.text}'),
              const Text('6: 직분은 귀찮아서 안 썼지만 '),
              const Text('이것도 controller로 제어'),
              const SizedBox(height: 40,),
              OutlinedButton(
                  onPressed: (){
                    /// offAll로 이전 라우트 Stack 다 없애주고
                    /// main으로 이동하는데, 이 때 tutorial 모드로 돌입하기 위해
                    /// argument를 하나 넘겨 준다. 더 안전한 방법이 있을지도 모르겠당.
                    authservice.register(
                        phoneNumber:controller.phoneCon.text,
                        name: controller.nameCon.text,
                        sex: controller.userSex.value==Sex.man?'남성':'여성',
                        nickname: controller.nicknameCon.text,
                        birth: controller.birthCon.text,
                        slideValue: controller.sliderValue.value);
                    Get.offAllNamed('/main',arguments: 'tutorial');
                  },
                  child: const Text('메인 페이지로 가기')
              )
            ],
          ),
        ),
      ),
    );
  }
  bool maketree(){

    return true;
  }
}

