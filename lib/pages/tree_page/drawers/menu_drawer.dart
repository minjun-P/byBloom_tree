import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bybloom_tree/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import '../../siginup_page/pages/signup_page_main.dart';

/// 우측 2번째 menu drawer
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height,
      child: SizedBox(
        width: Get.width*0.4,
        child: Column(

          children: [
            const SizedBox(
              height: 50,
            ),

            Container(
              padding: const EdgeInsets.only(top:50,bottom: 20),
              child: InkWell(
                  onTap: (){
                    authservice.logout();
                    Get.offAll(() => const SignupPageMain(),
                        transition: Transition.rightToLeftWithFade);

                  }, child:

              Column(
                children: const [
                  Icon(Icons.logout,color: Color(0xff959595),),
                  Text('로그아웃',style: TextStyle(color: Color(0xff959595)),),
                ],
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top:20,bottom: 20),
              child: InkWell(
                  onTap: (){
                    showresignPopup(context);
                  }, child:
              Column(
                children: const [
                  Icon(Icons.no_accounts,color: Color(0xff959595)),
                  Text('회원탈퇴',style: TextStyle(color: Color(0xff959595)),),
                ],
              )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top:20,bottom: 20),
              child: Obx(()=>InkWell(
                  onTap: (){
                    Get.find<NotificationController>().pushalarmtrue.value=!Get.find<NotificationController>().pushalarmtrue.value;
                    Get.find<NotificationController>().prefs.setBool('pushalarm', Get.find<NotificationController>().pushalarmtrue.value);
                  }, child:

              Column(
                children: [
                  Icon(Icons.doorbell,
                    color: Get.find<NotificationController>().pushalarmtrue.value ? Colors.black:const Color(0xff959595),),
                  const Text('푸쉬알람변경',style: TextStyle(color: Color(0xff959595)),),
                ],
              ))
              ),
            )


          ],
        ),
      ),
    );
  }
  Future<bool> showresignPopup(context) async {
    return await AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        title: '정말탈퇴하시겠어요?',
        desc: '저희는 당신의 신앙 도우미 bybloom이었습니다. 다음에 또 놀러오세요!',
        body: FractionallySizedBox(
          widthFactor: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('정말탈퇴하시겠어요?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Text('떠나신다니 아쉽습니다. 저희는 당신의 신앙 도우미 bybloom 이었습니다. 다음에 또 놀러오세요!')
            ],
          ),
        ),
        btnOkText: '아니오',
        btnOkOnPress: () {
          Get.back(closeOverlays: true);
        },
        btnCancelText: '네',
        btnCancelOnPress: () async {
          Get.toNamed('/signout');
          // 스택 다 지우고 로그인 화면으로


        }
    ).show();
  }
}
deleteallroomfromuser() {
  final doc= FirebaseFirestore.instance.collection('rooms')
      .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('updatedAt', descending: true).snapshots();
  doc.forEach((element) {
    for (var element in element.docs) {
      var id=element.id;
      FirebaseFirestore.instance.collection("rooms").doc(id).update({

        "userIds":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]) });
    }
  });
}

