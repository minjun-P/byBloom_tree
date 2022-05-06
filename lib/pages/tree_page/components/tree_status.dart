import 'package:badges/badges.dart';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

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
                  visible: controller.exp>=controller.expStructure[controller.level.toString()],
                  child: Column(
                    children: [
                      const Text('레벨업'),
                      GestureDetector(
                        onTap: ()async{
                          controller.levelUpAnimationController.forward().then((value) => controller.levelUpAnimationController.reset());
                          Future.delayed(const Duration(milliseconds: 3400)).then((value) => controller.levelUp(DbController.to.currentUserModel.value.level));
                        },
                        child: Lottie.asset(
                            'assets/tree/levelupicon.json',
                            width: 50,height: 50),
                      ),
                    ],
                  )),
          ),
          const SizedBox(height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
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
                                  const TextSpan(text: '성장단계 ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                  TextSpan(
                                      text: controller.level<8?'${controller.level.toString()} ':'최종',
                                    style: const TextStyle(fontWeight: FontWeight.bold)
                                  ),
                                ]
                            )
                        ),
                        Text.rich(
                            TextSpan(
                                children: [
                                  const TextSpan(text: '성장치 ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                  TextSpan(
                                      text: controller.exp.toString(),
                                      style: TextStyle(
                                          color: controller.exp>=controller.expStructure[controller.level.toString()]?Colors.red:Colors.black,
                                          fontWeight: controller.exp>=controller.expStructure[controller.level.toString()]?FontWeight.bold:FontWeight.w400
                                      )
                                  ),
                                  TextSpan(
                                      text: '/'+controller.expStructure[controller.level.toString()].toString()
                                  )
                                ]
                            )
                        ),
                        Obx(()=>
                          Text.rich(
                              TextSpan(
                                  children: [
                                    const TextSpan(text: '물 주기 횟수 ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),

                                    TextSpan(
                                        text: DbController.to.waterToLimit.value.toString()
                                    )
                                  ]
                              )
                          ),
                        ),
                      ],

                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                alignment: Alignment.centerLeft,
              ),
              // 받은 물의 수
              StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot){
                  if (snapshot.hasError){
                    return const Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Container();
                  }
                  // 받은 물의 누적 수

                  int len = List.castFrom(snapshot.data!.data()!['waterFrom']??[]).length;
                  // 경험치로 환산한 물의 수
                  int waterToExp = snapshot.data!.data()!['waterToExp']??0;
                  // 표시할 최종 num
                  int finalNum = len-waterToExp;
                  return Badge(
                    badgeContent: Text(finalNum.toString(),style: const TextStyle(color: Colors.white),),
                    badgeColor: Colors.blueGrey,
                    elevation: 2,
                    padding: const EdgeInsets.all(10),
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

                        child: Image.asset('assets/watering.png',width: 60,),
                      ),
                    );

                  },
                ),
              ],
            ),
          const SizedBox(height: 10,),
          /// 경험치 바, 어떻게 코드 짤지 고민을 좀 더 해보겠음
          Center(
            child: Stack(
              children: [
                Container(
                  width: Get.width*0.9,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white
                  ),
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.hardEdge,

                  child: Obx(()=> AnimatedContainer(
                    width: Get.width*0.9*controller.exp/controller.expStructure[controller.level.toString()],
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30)),
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


