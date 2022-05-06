import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';




class Tree extends GetView<TreeController>{
  const Tree({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final isLight = SchedulerBinding.instance?.window.platformBrightness == Brightness.light;
    return Stack(
      alignment: Alignment.center,
      children: [
        // 배경 - 다크모드 유무에 따라 배경 다르게
        isLight
            ?Image.asset('assets/tree/background_basic.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,)
            :Image.asset('assets/tree/background_dark.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,),
        // 나무
        Obx(()=>Positioned(
          top: 0,
            child: controller.level<8
                ?Image.asset('assets/tree/${controller.level}.gif',width: Get.width*0.9,fit: BoxFit.fitWidth)
                :CircleAvatar(backgroundColor: Colors.red,radius: 100,child: Text('만렙이올시다'),)
        )
          ,),
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
