import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/signup_gauge.dart';
import 'signup_page4.dart';
import 'package:pinput/pin_put/pin_put.dart';
import '';

/// 전화번호
bool phoneauthsucc=false;
FirebaseAuth auth =FirebaseAuth.instance;
TextEditingController smscontroller= new TextEditingController();
enum Status{Waiting, Error}
class SignupPage3 extends GetView<SignupController> {
  SignupPage3({Key? key}) : super(key: key);

  var _status=Status.Waiting;
  var phonenumber;
  var verificationId;





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

              child: const  Text('넘어가기',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              onPressed: phoneauthsucc==true?(){} :null,
              style: OutlinedButton.styleFrom(
                  primary: phoneauthsucc==true?Colors.blue :Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  side: BorderSide(width: 2),
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
                    TextButton(

                        onPressed: () {
                          if (_status == Status.Waiting) {
                            verifyphone();
                            showDialog(context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('전화번호인증'),
                                    content: PinPut(
                                      controller: smscontroller,
                                      eachFieldHeight: 50,
                                      fieldsCount: 6,
                                      submittedFieldDecoration: _pinPutDecoration
                                          .copyWith(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                      ),
                                      selectedFieldDecoration: _pinPutDecoration,
                                      followingFieldDecoration: _pinPutDecoration
                                          .copyWith(
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                        border: Border.all(
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(.5),
                                        ),
                                      ),
                                    ),


                                    actions: [
                                    ],
                                  );
                                });
                          }

                        }
                          ,
                        child:
                    TextButton(child:Text('인증하기'),onPressed: (),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool? verifyphone(){
    auth.verifyPhoneNumber(
        phoneNumber: "+82"+controller.phoneCon.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value)=>{
            print("logged in")
          });
        },
        verificationFailed: (FirebaseAuthException exception){},
        codeSent: (String verificationID, int? resendToken) async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode:smscontroller.text );
          await auth.signInWithCredential(credential);
          },
        codeAutoRetrievalTimeout: (String verificationID){});

    return null;
  }



  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

}