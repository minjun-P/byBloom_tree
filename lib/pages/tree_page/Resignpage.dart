
import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'drawers/menu_drawer.dart';

FirebaseAuth auth =FirebaseAuth.instance;

/// 계정 삭제 이전, 재인증 페이지
class ResignPagePhone extends GetView<SignupController> {
  ResignPagePhone({Key? key}) : super(key: key);
  late String verificationID;
  @override
  Widget build(BuildContext context) {
    // 0.5초 뒤 키보드 뜨게 하기
    Future.delayed(const Duration(milliseconds: 500), () =>
        controller.page3FocusNode1.requestFocus());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  const Text('회원탈퇴',
            style: TextStyle(color: Colors.black, fontSize: 20),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              const Text('핸드폰인증하기',
                style: TextStyle(color: Colors.black, fontSize: 20),),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: controller.page3Key,
                      child: Column(
                          children: <Widget>[
                            SignupTextField(
                              focusNode: controller.page3FocusNode1,
                              textController: controller.phoneCon,
                              keyboardType: TextInputType.phone,

                              labelText: '전화번호',
                              hintText: '01012345678',
                              helperText: '\'-\' 없이 숫자로만 쭉 입력해주세요',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '올바른 전화번호 값을 입력하세요';
                                }
                                if (value.length != 11) {
                                  return '번호가 8자리가 아닙니다';
                                }
                                else {
                                  return null;
                                }
                              },

                              // 애초에 숫자만 입력되도록
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      SignupTextField(
                                        focusNode: controller.page3FocusNode2,
                                        textController: controller.smsCon,
                                        keyboardType: TextInputType.number,

                                        labelText: '인증번호',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return '올바른 인증번호 값을 입력하세요';
                                          }
                                          if (value.length != 6) {
                                            return '인증번호가 6자리가 아닙니다';
                                          }
                                          else {
                                            return null;
                                          }
                                        },

                                        // 애초에 숫자만 입력되도록
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                      Obx(()=>
                                          Visibility(
                                            visible: controller.countdown.value,
                                            child: Positioned(
                                              right: 30,
                                              top: 12,
                                              bottom: 0,
                                              child: Countdown(
                                                controller: controller.countdownController,
                                                seconds: 120,
                                                build: (context, time){
                                                  return Text(
                                                    time.toInt().toString()+' 초',
                                                    style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 14
                                                    ),
                                                  );
                                                },
                                                onFinished: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return const AlertDialog(
                                                          title: Text('인증번호가 만료되었습니다!'),
                                                          content: Text('다시 인증번호를 받아주세요!'),
                                                        );
                                                      }
                                                  );
                                                  controller.countdown(false);
                                                },
                                              ),
                                            ),
                                          ),
                                      )

                                    ],
                                  ),
                                ),
                                const SizedBox(width: 25,),
                                Column(
                                  children: [
                                    OutlinedButton(
                                        child: const Text(
                                          '인증번호 받기',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: (){
                                          loginWithPhone();
                                          controller.countdown(true);
                                          Future.delayed(const Duration(seconds: 1),(){
                                            controller.countdownController.start();
                                          });

                                        },
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.green,width: 2)
                                        )
                                    ),
                                    Obx(()=>
                                        OutlinedButton(
                                          child: Text(
                                              '인증하기',
                                              style: TextStyle(color: controller.countdown.value?Colors.green:Colors.black)
                                          ),
                                          onPressed: controller.countdown.value?(){
                                            verifyOTP();
                                          }:null,
                                          style: OutlinedButton.styleFrom(
                                              side: controller.countdown.value?const BorderSide(color: Colors.green,width: 2):null
                                          ),
                                        ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Obx(()=>
                                Visibility(
                                  visible: controller.phonesuc.value,
                                  child: OutlinedButton(
                                    child: const Text('회원탈퇴'),
                                    onPressed: ()async {
                                      Get.offAllNamed('/login');
                                      // Db room doc 사제
                                      deleteallroomfromuser();
                                      //Db 하위 collection 삭제
                                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('waterTo').get()
                                          .then((snapshot) {
                                        for (DocumentSnapshot ds in snapshot.docs){
                                          ds.reference.delete();

                                        } });

                                      // Db doc 삭제
                                      
                                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();
                                      // auth 삭제
                                      try {
                                        await FirebaseChatCore.instance.deleteUserFromFirestore(FirebaseAuth.instance.currentUser!.uid);
                                        // re - authenticate 이후에 delete 가능함. 다시 인증 받는 방식으로!
                                        FirebaseAuth.instance.currentUser!.delete();
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'requires-recent-login') {

                                        }
                                      }

                                    },
                                  ),
                                ),
                            ),
                            const SizedBox(height: 20,),
                          ]
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
//인증번호수신
  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: "+82" + controller.phoneCon.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          controller.phonesuc.value=true;

        });
      },
      verificationFailed: (FirebaseAuthException e) {
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }
  // 로그인메소드
  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: controller.smsCon.text);

    await auth.signInWithCredential(credential).then((value) {
      controller.phonesuc.value=true;

    });
  }

}