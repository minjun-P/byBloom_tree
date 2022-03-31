import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/main.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
Stream<DocumentSnapshot> documentStream= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots();
//유저등록

class TreeStatus extends GetView<TreeController> {
  const TreeStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// 임시 물 받기 아이콘
          Obx(()=>
            Visibility(
              visible: controller.exp.value>=100,
                child: Column(
                  children: [
                    Text('레벨업'),
                    GestureDetector(
                      onTap: ()async{
                        controller.levelUpAnimationController.forward().then((value) => controller.levelUpAnimationController.reset());
                        Future.delayed(Duration(milliseconds: 3400)).then((value) => controller.templevelUp());




                      },
                      child: Lottie.asset(
                          'assets/45717-arrow-up.json',
                          width: 50,height: 50),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 60,
              ),
              onPressed: ()async{
                await controller.levelUpAnimationController.forward();
                Future.delayed(Duration(milliseconds: 800)).then((value) => controller.templevelUp());
                controller.levelUpAnimationController.reverse();

                },),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 60,
              ),
              onPressed: (){
                // 임시로 태현이형 위해서
                /// 경험치 증가 테스팅
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                    {'exp':controller.exp.value+10});
                /// 푸시알람 테스팅
                //controller.show();
              },),
          ),
          const SizedBox(height: 10,),
          /// 경험치 바, 어떻게 코드 짤지 고민을 좀 더 해보겠음
          Container(
            width: 500,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white
            ),
            alignment: Alignment.centerLeft,

            child: Obx(()=> FractionallySizedBox(
              widthFactor: controller.exp.value.toDouble()/100,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green.shade100
                ),
              ),

            ),
            )
          ),

        ],
      ),
    );
  }
}


