import 'package:badges/badges.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/main.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../mission_page/mission_controller.dart';
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
          // 레벨업 버튼, 경험치가 꽉 차거나 초과해야 visible 해짐.
          Obx(()=>
              Visibility(
                  visible: controller.exp.value>=controller.expStructure[controller.level.value.toString()],
                  child: Column(
                    children: [
                      Text('레벨업'),
                      GestureDetector(
                        onTap: ()async{
                          controller.levelUpAnimationController.forward().then((value) => controller.levelUpAnimationController.reset());
                          Future.delayed(Duration(milliseconds: 3400)).then((value) => controller.levelUp());
                        },
                        child: Lottie.asset(
                            'assets/45717-arrow-up.json',
                            width: 50,height: 50),
                      ),
                    ],
                  )),
          ),
          SizedBox(height: 10,),

          // 받은 물의 수
          StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                return Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting){
                return Container();
              }
              // 받은 물의 누적 수
              int len = List.castFrom(snapshot.data!.data()!['waterFrom']).length;
              // 경험치로 환산한 물의 수
              int waterToExp = snapshot.data!.data()!['waterToExp']??0;
              // 표시할 최종 num
              int finalNum = len-waterToExp;
              return Badge(
                badgeContent: Text(finalNum.toString(),style: TextStyle(color: Colors.white),),
                padding: EdgeInsets.all(7),
                child: GestureDetector(
                  onTap: () async{
                    if (finalNum>0){
                      await controller.wateringController.forward();
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                        'waterToExp':FieldValue.increment(finalNum)
                      });
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                        'exp':FieldValue.increment(finalNum)
                      });
                      Get.snackbar('title', '친구들의 물주기 덕분에 경험치가 $finalNum 증가했어요!');
                      controller.wateringController.reset();
                    }

                  },
                  child: Container(
                      padding: EdgeInsets.only(bottom: 5,left: 3,right: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white,width: 4)
                      ),
                      child: Icon(MdiIcons.wateringCanOutline,size: 40,color: Colors.white,)
                  ),
                ),
              );

            },
          ),


          Align(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Obx(()=>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(text: '성장단계 : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                              TextSpan(
                                  text: '${controller.level.value.toString()} ',
                                style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(text: '성장치 ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                              TextSpan(
                                  text: controller.exp.value.toString(),
                                  style: TextStyle(
                                      color: controller.exp.value>=controller.expStructure[controller.level.value.toString()]?Colors.red:Colors.black,
                                      fontWeight: controller.exp.value>=controller.expStructure[controller.level.value.toString()]?FontWeight.bold:FontWeight.w400
                                  )
                              ),
                              TextSpan(
                                  text: '/'+controller.expStructure[controller.level.value.toString()].toString()
                              )
                            ]
                        )
                    )
                  ],
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 10,),
          /// 경험치 바, 어떻게 코드 짤지 고민을 좀 더 해보겠음
          Center(
            child: Stack(
              children: [
                Container(
                  width: Get.width*0.9,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white
                  ),
                  alignment: Alignment.centerLeft,

                  child: Obx(()=> AnimatedContainer(
                    width: Get.width*0.9*controller.exp.value/controller.expStructure[controller.level.value.toString()],
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green.shade100
                    ),
                  ),
                  )
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


