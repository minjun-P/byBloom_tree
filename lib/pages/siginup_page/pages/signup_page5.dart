import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/signup_gauge.dart';
import 'signup_page6.dart';
import 'package:bybloom_tree/Profile/profilephoto.dart';
/// 내가 만든 uploadphoto함수의 특성때문에 4~5번 페이지 순서바꿨어
/// 닉네임, 프로필 사진
class SignupPage5 extends GetView<SignupController> {
  const SignupPage5({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String? downloadUrl=null;

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

                  Get.to(()=>const SignupPage6(),transition: Transition.rightToLeftWithFade);
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
                        child: const Text('프로필 사진 설정하기'),
                        onPressed: (){

                          showDialog(context: context, builder: (context){
                            return AlertDialog(

                              elevation: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 5,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('프로필변경')
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(onPressed: () async {
                                  downloadUrl = await AddProfilePhoto();

                                  Navigator.pop(context);
                                }, child: Text('예')),
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text('아니오'))
                              ],
                            );
                          }
                          );

                        },
                      ),
                    ),
                    Center(
                      child: downloadUrl == null? CircleAvatar(
                        backgroundColor: Colors.lightGreen,radius: 80,
                      ): CircleAvatar(
                        radius: 80,
                        backgroundImage: ExtendedNetworkImageProvider(downloadURL!,cache: true,scale:1)
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