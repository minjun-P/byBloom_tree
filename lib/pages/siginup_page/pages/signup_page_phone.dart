import 'package:bybloom_tree/auth/authservice.dart';
import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/pages/siginup_page_fin.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../components/signup_gauge.dart';
import 'signup_page_church.dart';


/// 전화번호

FirebaseAuth auth =FirebaseAuth.instance;

enum Status{Waiting, Error}

class SignupPagePhone extends GetView<SignupController> {
  SignupPagePhone({Key? key}) : super(key: key);

  final _status = Status.Waiting;
  late String verificationID;


  @override
  Widget build(BuildContext context) {
    // 0.5초 뒤 키보드 뜨게 하기
    Future.delayed(const Duration(milliseconds: 500), () =>
        controller.page3FocusNode1.requestFocus());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupGauge(minusWidth: 80),
              SizedBox(height: 30,),
              Text('휴대폰 본인 인증',
                style: TextStyle(color: Colors.black, fontSize: 20),),
              SizedBox(height: 20,),
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
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                      fontSize: 14
                                                    ),
                                                  );
                                                },
                                                onFinished: (){
                                                  if(auth.currentUser==null)
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
                                SizedBox(width: 25,),
                                Column(
                                  children: [
                                    OutlinedButton(
                                      child: Text(
                                          '인증번호 받기',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: (){
                                        if (_status == Status.Waiting) {
                                          loginWithPhone();
                                          controller.countdown(true);
                                          Future.delayed(const Duration(seconds: 1),(){
                                            controller.countdownController.start();
                                          });
                                        }
                                      },
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: Colors.green,width: 2)
                                        )
                                    ),
                                    Obx(()=>
                                      OutlinedButton(
                                        child: Text(
                                          '인증하기',
                                            style: TextStyle(color: controller.countdown.value?Colors.green:Colors.black)
                                        ),
                                        onPressed: controller.countdown.value?(){
                                          if (_status == Status.Waiting) {
                                            verifyOTP();
                                          }
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
                            SizedBox(height: 20,),
                            Obx(()=>
                                Visibility(
                                  visible: controller.phonesuc.value,
                                  child: OutlinedButton(
                                    child: Text('회원가입 완료'),
                                    onPressed: (){
                                      // 디비에 계정 등록
                                      authservice.register(
                                          phoneNumber: controller.phoneCon.text,
                                          name: controller.nameCon.text,
                                          sex: controller.userSex.value==Sex.man?'남성':'여성',
                                          nickname: controller.nicknameCon.text,
                                          birth: controller.birthCon.text,
                                          slideValue: controller.sliderValue.value,
                                          church: controller.churchCon.text,
                                          // 이미지 name.png 을 넣어주기
                                          profileImage: controller.profileList[controller.selectedProfile.value]
                                      );
                                      Get.offAll(()=>SignupPageFin());
                                    },
                                  ),
                                ),
                            ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('안드로이드 핸드폰은 인증 문자가 오면 입력 없이 자동으로 넘어갑니다.',style: TextStyle(color: Colors.grey,fontSize: 12),),
                          )
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
          print("login with phone ");
          controller.phonesuc.value=true;

        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
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
      print("verify otp");
      controller.phonesuc.value=true;

    });
  }


  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

}