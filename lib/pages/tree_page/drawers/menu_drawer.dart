import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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
            SizedBox(
              height: 50,
            ),

            Container(
              padding: EdgeInsets.only(top:50,bottom: 20),
              child: InkWell(
                  onTap: (){
                    authservice.logout();
                    Get.offAll(() => SignupPageMain(),
                        transition: Transition.rightToLeftWithFade);

                  }, child:

              Column(
                children: [
                  Icon(Icons.logout),
                  Text('로그아웃'),
                ],
              )),
            ),
            Container(
              padding: EdgeInsets.only(top:20,bottom: 20),
              child: InkWell(
                  onTap: (){

                    showresignPopup(context);


                  }, child:

              Column(
                children: [
                  Icon(Icons.no_accounts),
                  Text('회원탈퇴'),
                ],
              )
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:20,bottom: 20),
              child: Obx(()=>InkWell(
                  onTap: (){
                    Get.find<NotificationController>().pushalarmtrue.value=!Get.find<NotificationController>().pushalarmtrue.value;
                    Get.find<NotificationController>().prefs.setBool('pushalarm', Get.find<NotificationController>().pushalarmtrue.value);
                    print(Get.find<NotificationController>().pushalarmtrue.value);
                  }, child:

              Column(
                children: [
                  Icon(Icons.doorbell,
                    color: Get.find<NotificationController>().pushalarmtrue.value ? Colors.black:Colors.grey,),
                  Text('푸쉬알람변경'),
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
          // 스택 다 지우고 로그인 화면으로
          Get.offAllNamed('/login');
          // Db room doc 사제
          deleteallroomfromuser();
          // Db doc 삭제
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();
          // auth 삭제
          try {
            await FirebaseChatCore.instance.deleteUserFromFirestore(FirebaseAuth.instance.currentUser!.uid);
            // re - authenticate 이후에 delete 가능함. 다시 인증 받는 방식으로!
            FirebaseAuth.instance.currentUser!.delete();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'requires-recent-login') {
              print('The user must reauthenticate before this operation can be executed.');
            }
          }


        }
    ).show();
  }
}
deleteallroomfromuser() {
  final doc= FirebaseFirestore.instance.collection('rooms')
      .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('updatedAt', descending: true).snapshots();
  doc.forEach((element) {
    element.docs.forEach((element) {
      var id=element.id;
      FirebaseFirestore.instance.collection("rooms").doc(id).update({

        "userIds":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]) });
    });
  });
}

