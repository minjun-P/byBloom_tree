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
        Image.asset('assets/tree/background_basic.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,),
        Obx(()=>
          Visibility(
            visible: controller.rain.value,
              child: Lottie.asset('assets/tree/cloud.json',width: Get.width*0.9,fit: BoxFit.fitWidth)
          ),
        ),
        Obx(()=>Image.asset('assets/tree/${controller.level.value}.gif',width: Get.width*0.9,fit: BoxFit.fitWidth),),
        Obx(()=>
          Visibility(
            visible: controller.rain.value,
              child: Lottie.asset('assets/tree/rain.json',width: Get.width*0.9,fit: BoxFit.fitWidth)
          ),
        )
      ],
    );
  }

}
