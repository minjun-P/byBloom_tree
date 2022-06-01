import 'dart:math';

import 'package:badges/badges.dart';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/firend_page/firend_profile_controller.dart';
import 'package:bybloom_tree/pages/forest_page/pages/forest_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../main_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'components/friend_tree.dart';

class FriendProfilePage extends GetView<FriendProfileController> {
  const FriendProfilePage({
    Key? key,
    required this.friendData
  }) : super(key: key);

  final FriendModel friendData;

  @override
  Widget build(BuildContext context) {
    Get.put(FriendProfileController());
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 170),
          child: Stack(
            children: [
              // 친구 나무
              FriendTree(friendData: friendData,),
              Positioned.fill(
                  child: Lottie.asset(
                      'assets/tree/shower.json',
                    controller: controller.wateringController
                  )
              ),
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    icon: const Icon(MdiIcons.arrowLeft,color: Colors.white,size: 35,),
                  onPressed: (){
                      Get.back();
                  },
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SlideTransition(
                      position: controller.containerAnimation,
                      child: Obx(()=>
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10)
                          ),

                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                          child: controller.waterTo.contains(friendData.uid)
                              ?const Text('물을 주셔서 감사해요!')
                              :const Text('친구의 나무에 물을 주세요!')
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),

                    GestureDetector(
                      onTap: ()async{

                        // 물을 준 횟수가 3번 이상이면
                        if (controller.waterTo.length>=3){
                          Get.snackbar('띵동', '이미 오늘 줄 수 있는 물을 다 주셨어요!');
                          return ;
                        }
                        // 물을 준 적이 없다면
                        if (!controller.waterTo.contains(friendData.uid)){
                          for (var token in friendData.tokens) {
                            Get.find<MainController>().sendFcm(
                                token: token,
                                title: '${DbController.to.currentUserModel.value.name}님이 나무에 물을 주셨어요',
                                body: '얼른 확인해보세요!'
                            );
                          }
                          controller.saveWateringRecord(friendData.uid,friendData.name);
                          await controller.wateringController.forward();
                          controller.wateringController.reset();
                          controller.containerController.stop();

                          Get.snackbar('띵동', '${friendData.name}님에게 물을 주셨어요!');
                        } else {
                          // 물을 준 적이 있다면
                          Get.snackbar('띵동', '이미 물을 주셨어요!');
                        }


                      },
                      child: Obx(()=>
                        Badge(
                          showBadge: controller.waterTo.contains(friendData.uid)?true:false,
                          badgeContent: const Icon(Icons.check,size: 15,),
                          badgeColor: Colors.cyan,
                          child: Image.asset(
                            'assets/watering_to_friend.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 190,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friendData.name,
                        style: const TextStyle(
                            fontSize: 21
                        ),),
                      Text(friendData.nickname)
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () async {
                        String gradcolor1=(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString();
                        String gradcolor2=(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString();
                        String imageindex=gradcolor1+","+gradcolor2;

                          final room2 = await FirebaseChatCore.instance
                              .createRoom(types.User(
                              id: (await finduidFromPhone(
                                  friendData.phoneNumber))!), metadata: {
                            'name': friendData.name,
                            'imageUrl':friendData.profileImage
                          }
                         );

                          Navigator.of(context).push(

                            MaterialPageRoute(
                              builder: (context) =>
                                  ForestChatRoom(
                                    room: room2,
                                  ),
                            ),
                          );


                      },
                  child:Icon(MdiIcons.messageProcessingOutline,color: Colors.grey.shade400,size: 35,)


                  ),
                  const SizedBox(width: 20,)
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
                  future: FirebaseFirestore.instance.collection('users').doc(friendData.uid).collection('mission_completed').get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){
                      return const Text('error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return const Text('Loading');
                    }
                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                    List<QueryDocumentSnapshot> filteredDocs = docs.where((element){
                      Map<String,dynamic> map = element.data() as Map<String,dynamic>;
                      return map.isNotEmpty;
                    }).toList();
                    int sum = 0;
                    for (var element in filteredDocs) {
                      Map<String,dynamic> map = element.data() as Map<String,dynamic>;
                      sum+=map.keys.length;
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconWithNum(MdiIcons.calendarBlank,'달성 일수',filteredDocs.length),
                        const SizedBox(width: 40,),
                        _buildIconWithNum(MdiIcons.clockOutline,'달성 횟수',sum),
                      ],
                    );
                  }
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  _buildIconWithNum(IconData icon, String title,int num) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 15,),
        Column(
          children: [
            Icon(icon,size: 25,color: Colors.grey,),
            Text(title,style: const TextStyle(fontSize: 14,color: Colors.grey),),
            
          ],
        ),
        const SizedBox(width: 10,),
        Text(num.toString(),style: const TextStyle(fontSize: 20,color: Colors.grey),),
        const SizedBox(width: 15,),
      ],
    );
  }
}

