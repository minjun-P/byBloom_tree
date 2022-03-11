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
        Image.asset('assets/tree/background_3.jpg',width: Get.width,fit: BoxFit.fitWidth,),
        Lottie.asset('assets/tree/tree.json',width: Get.width,fit: BoxFit.fitWidth),
        //Lottie.asset('assets/plane.json')
        /**
        Image.asset(
          'assets/real_tree_background.jpg',
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        ),*/
        //Image.asset('assets/tree/tree_2_moving.gif'),
        /**
            Obx(()=> Image.asset(
            'assets/tree/tree_${Get.find<TreeController>().treeGrade.value}.png',
            fit: BoxFit.fill,
            height: Get.height,
            width: Get.width,
            ))**/
      ],
    );
  }

}
