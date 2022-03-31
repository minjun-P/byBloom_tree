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
        // 구름
        Obx(()=>
          Visibility(
            visible: controller.rain.value,
              child: Lottie.asset('assets/tree/cloud.json',width: Get.width*0.9,fit: BoxFit.fitWidth)
          ),
        ),
        // 나무
        Obx(()=>Image.asset('assets/tree/${controller.level.value%7}.gif',width: Get.width*0.9,fit: BoxFit.fitWidth),),
        // 바람
        Obx(()=>
          Visibility(
            visible: controller.rain.value,
              child: Lottie.asset('assets/tree/rain.json',width: Get.width*0.9,fit: BoxFit.fitWidth)
          ),
        ),

        Visibility(
          visible: true,
            child: Lottie.asset(
                'assets/tree/levelup4.json',
              width: Get.width,
              height: Get.height,
              fit: BoxFit.fill,
              controller: controller.levelUpAnimation
            )
        )
      ],
    );
  }

}
