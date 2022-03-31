import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../components/signup_gauge.dart';
import 'signup_page4.dart';


/// 전화번호

FirebaseAuth auth =FirebaseAuth.instance;

enum Status{Waiting, Error}
class SignupPage3 extends GetView<SignupController> {
  SignupPage3({Key? key}) : super(key: key);

  var _status = Status.Waiting;
  var phonenumber;
  var verificationID;


  @override
  Widget build(BuildContext context) {
    // 0.5초 뒤 키보드 뜨게 하기
    Future.delayed(const Duration(milliseconds: 500), () =>
        controller.page3FocusNode1.requestFocus());
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: OutlinedButton(

              child: const Text('넘어가기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              onPressed:  (){print(controller.phonesuc.value);
              controller.phonesuc.value == true ? () {
                Get.to(() => SignupPage4(),
                    transition: Transition.rightToLeftWithFade);

              } : (){};},
              style: OutlinedButton.styleFrom(
                  primary: controller.phonesuc.value == true ? Colors.blue : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  side: BorderSide(width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupGauge(minusWidth: 120),
              SizedBox(height: 30,),
              Text('더 자세히 알려주세요!',
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
                                                  if(auth.currentUser.isNull)
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
                                    )
                                  ],
                                ),
                              ],
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
          print("You are logged in successfully");
          controller.phonesuc.value=true;
          Get.to(() => SignupPage4(),
              transition: Transition.rightToLeftWithFade);

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
      print("You are logged in successfully");
      controller.phonesuc.value=true;
      Get.to(() => SignupPage4(),
          transition: Transition.rightToLeftWithFade);
    });
  }


  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

}