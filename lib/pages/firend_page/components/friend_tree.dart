import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/firend_page/firend_profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class FriendTree extends GetView<FriendProfileController> {
  const FriendTree({
    Key? key,
    required this.friendData
  }) : super(key: key);
  final FriendModel friendData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 배경
        Image.asset('assets/tree/background_basic.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,),
        // 나무
        StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(friendData.uid).snapshots(),
          builder: (context,snapshot) {
            if (snapshot.hasError){
              return Text('error');
            }
            if (snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator(color: Colors.grey.shade200,);
            }
            return Image.asset('assets/tree/${snapshot.data!.data()!['level']}.gif',width: Get.width*0.9,fit: BoxFit.fitWidth);
          }
        ),
        Lottie.asset(
            'assets/tree/shower.json',
            controller: controller.wateringController
        ),
      ],
    );
  }
}
