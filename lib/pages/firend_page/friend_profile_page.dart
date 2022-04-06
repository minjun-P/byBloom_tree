import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/firend_page/firend_profile_controller.dart';
import 'package:bybloom_tree/pages/forest_page/pages/forest_chat_room.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../main_controller.dart';
import '../tree_page/components/tree.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

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
          padding: const EdgeInsets.only(bottom: 120),
          child: Stack(
            children: [
              Tree(),
              Positioned.fill(
                  child: Lottie.asset(
                    'assets/tree/cloud.json',
                    controller: controller.wateringAnimation
                  )
              ),
              Positioned.fill(
                child: Lottie.asset(
                    'assets/tree/rain.json',
                  controller: controller.wateringAnimation
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('안녕하세요',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
                    Text('${friendData.name}님의 나무입니다', style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)
                  ],
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

                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                          width: 150,
                          child: controller.watered.value
                              ?Text('물을 주셔서 감사해요!')
                              :Text('친구의 나무에 물을 주세요!')
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

                    GestureDetector(
                      onTap: ()async{
                        await controller.wateringController.forward();
                        controller.wateringController.reset();
                        controller.containerController.stop();

                        friendData.tokens.forEach((token) {
                          Get.find<MainController>().sendFcm(
                              token: token,
                              title: '${Get.find<TreeController>().currentUserModel!.name}님이 나무에 물을 주셨어요',
                              body: '얼른 확인해보세요!'
                          );
                        });


                        controller.watered(true);
                        showDialog(
                            context: context,
                            builder: (context)=>AlertDialog(
                              title: Text('${friendData.name}님에게 물을 주셨어요!'),
                              content: Text('${Get.find<TreeController>().currentUserModel!.name}님 덕분에 ${friendData.name}님의 경험치가 10 증가했어요!'),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                child: Text('네'),
                                onPressed: (){Get.back(closeOverlays: true);},
                              )],
                            )
                        );
                      },
                      child: Obx(()=>
                        Container(
                          padding: EdgeInsets.only(bottom: 5,left: 3,right: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            border: Border.all(color: controller.watered.value?Colors.white:Colors.cyan,width: 4)
                          ),
                          child: Icon(MdiIcons.wateringCanOutline,size: 40,color: controller.watered.value?Colors.white:Colors.cyanAccent,)
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
          height: 150,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),

          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          print(friendData.toJson());
                        },
                        child: Text(
                          friendData.name,
                          style: TextStyle(
                              fontSize: 21
                          ),),
                      ),
                      Text(friendData.nickname)
                    ],
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () async {
                        final room2=await FirebaseChatCore.instance.createRoom(types.User(id:(await finduidFromPhone(friendData.phoneNumber!))!),metadata: {'name':friendData.name});

                        Navigator.of(context).push(

                          MaterialPageRoute(
                            builder: (context) => ForestChatRoom(
                              room: room2,
                            ),
                          ),
                        );
                      },
                  child:Icon(MdiIcons.messageProcessingOutline,color: Colors.grey.shade400,size: 35,)


                  ),
                  SizedBox(width: 20,)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconWithNum(MdiIcons.clockOutline,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(MdiIcons.checkboxOutline,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(MdiIcons.calendarWeekendOutline,120),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  _buildIconWithNum(IconData icon, int num) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,size: 25,color: Colors.grey,),
        SizedBox(width: 10,),
        Text(num.toString(),style: TextStyle(fontSize: 16,color: Colors.grey),)
      ],
    );
  }
}

