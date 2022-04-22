import 'package:badges/badges.dart';
import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/pages/signup_page_phone.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/signup_gauge.dart';
import 'signup_page6.dart';
import 'package:bybloom_tree/Profile/profilephoto.dart';
/// 내가 만든 uploadphoto함수의 특성때문에 4~5번 페이지 순서바꿨어
/// 닉네임, 프로필 사진
class SignupPageProfile extends GetView<SignupController> {
  const SignupPageProfile({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              child: const Text('작성완료',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
              onPressed: (){
                if (controller.pageNicknameKey.currentState!.validate()){

                  Get.to(()=> SignupPagePhone(),transition: Transition.rightToLeftWithFade);
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
              const SignupGauge(minusWidth: 100,),
              const SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  // 특이하게 reverse 를 true로 해놓음. 이렇게 해야 키보드가 올라올 때 textfield가 안 짤려서 UX가 좋다.
                  reverse: false,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('프로필 사진 고르기',style: TextStyle(color: Colors.black,fontSize: 20),),
                        Text('맘에 드는 이미지를 클릭해주세요!',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        const SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(9, (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  controller.selectedProfile(index);
                                },
                                child: Obx(()=>
                                    Badge(
                                      showBadge: controller.selectedProfile.value==index,
                                      badgeContent: Icon(Icons.check,color: Colors.white,),
                                      badgeColor: Colors.lightBlue,
                                      child: Image.asset(
                                        'assets/profile/${controller.profileList[index]}.png',
                                        width: 120,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                ),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text('별명 설정',style: TextStyle(color: Colors.black,fontSize: 20),),
                        SizedBox(height: 10,),
                        Form(
                            key: controller.pageNicknameKey,
                            child: SignupTextField(
                              focusNode: controller.pageNicknameFocusNode1,
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
                        const SizedBox(height: 80,),

                      ],
                    ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}