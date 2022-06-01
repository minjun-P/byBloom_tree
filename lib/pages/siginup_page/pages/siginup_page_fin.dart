import 'package:bybloom_tree/auth/FriendAdd.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/firend_page/friend_add_page.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPageFin extends GetView<SignupController> {
  const SignupPageFin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text('이제 연락처로\n 친구들을 찾아보아요',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
              /// 연락처연동해서 가입자중 친구리스트만 받아와서 이를 리스트타일로 뿌려주는 로직구현
              const SizedBox(height: 40,),
              OutlinedButton(
                  onPressed: () async {
                Get.to(const FriendAddPage( ));
                List<FriendModel>? s=await findfriendwithcontact(controller.phoneCon.text);
                for (var element in s!) {
                }
                Get.to(const FriendAddPage());


              }, child: const Text('연락처 연동해서 친구찾기',style: TextStyle(fontSize: 18),)),

              const SizedBox(height: 40,),
              TextButton(
                  onPressed: (){
                    Get.offAllNamed('/main');
                  },
                  child: const Text('건너 뛰기',style: TextStyle(color: Colors.grey,fontSize: 16))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
