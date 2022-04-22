import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';

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
              const SizedBox(

                child:Text('마지막으로 연락처로 친구들을 찾아보아요')
              ),
              /// 연락처연동해서 가입자중 친구리스트만 받아와서 이를 리스트타일로 뿌려주는 로직구현
              OutlinedButton(onPressed: () async {
                List<FriendModel>? s=await findfriendwithcontact();
                s?.forEach((element) {
                  print(element.phoneNumber);
                });
                showDialog(context: context, builder:(context){
                  return ListView.builder(
                      itemCount: s?.length,
                      itemBuilder:(BuildContext context,int index){
                        return ListTile(
                          leading: Text(s![index].phoneNumber),
                        );
                      }
                      );

                });


              }, child:

               Text('연락처연동해서친구찾기')),
              const SizedBox(height: 40,),
              OutlinedButton(
                  onPressed: (){
                    /// offAll로 이전 라우트 Stack 다 없애주고
                    /// main으로 이동하는데, 이 때 tutorial 모드로 돌입하기 위해
                    /// argument를 하나 넘겨 준다. 더 안전한 방법이 있을지도 모르겠당.
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

}

