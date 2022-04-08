import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';




class Tree extends GetView<TreeController>{
  const Tree({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 배경
        Image.asset('assets/tree/background_basic.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,),
        // 나무
        Obx(()=>Image.asset('assets/tree/${controller.level}.gif',width: Get.width*0.9,fit: BoxFit.fitWidth),),
        Lottie.asset(
          'assets/tree/shower.json',
          controller: controller.wateringController
        ),

        Lottie.asset(
            'assets/tree/levelup.json',
          width: Get.width,
          height: Get.height,
          fit: BoxFit.fill,
          controller: controller.levelUpAnimation
        )
      ],
    );
  }

}
