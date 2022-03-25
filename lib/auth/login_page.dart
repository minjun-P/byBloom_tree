import 'package:bybloom_tree/auth/login_controller.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../pages/siginup_page/components/signup_textfield.dart';


FirebaseAuth auth =FirebaseAuth.instance;


class loginScreen extends GetView<LoginController> {
   loginScreen({Key? key}) : super(key: key);

   var phonenumber;
   var verificationID;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () =>
        controller.loginpageFocusNode1.requestFocus());
    // TODO: implement build
   return  SafeArea(
        child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [

         SizedBox(height: 30,),
         Text('바이블룸 로그인',
           style: TextStyle(color: Colors.green, fontSize: 40 ,fontWeight: FontWeight.bold ),),
         SizedBox(height: 20,),
         Expanded(
           child: ListView(
             children: [
               Form(
                 key: controller.loginpageKey,
                 child: Column(
                     children: <Widget>[
                       SignupTextField(
                         focusNode: controller.loginpageFocusNode1,
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
                       SignupTextField(
                         focusNode: controller.loginpageFocusNode2,
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
                       )
                     ]
                 ),
               ),
               Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     TextButton(
                         child: Text("인증번호받기"),
                         onPressed: () {
                           loginWithPhone();
                           }

                     ),
                     TextButton(
                         child: Text("로그인하기"),
                         onPressed: () {
                          {
                             verifyOTP();
                           }
                         }
                     )
                   ]
               )
             ],
           ),
         ),
         ElevatedButton(
           onPressed: (){
             Get.offAllNamed('/main');
           },
           child: Text('메인스크린 이동'),
         )
       ],
     ),
   ),
        )

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
           Get.offAllNamed('/main');
         });
       },
       verificationFailed: (FirebaseAuthException e) {
         print(e.message);
       },
       codeSent: (String verificationId, int? resendToken) {
         verificationID = verificationId;
           AlertDialog(
             content: Text("인증번호 혹은 전화번호가 잘못되었습니다."),
           );

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
       Get.offAllNamed('/main');

     });
   }

}
