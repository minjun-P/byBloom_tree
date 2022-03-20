import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class Tree extends GetView<TreeController>{
  const Tree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/tree/basic_background.jpg',width: Get.width,height: Get.height,fit: BoxFit.fill,),
        Obx(()=>Image.asset('assets/tree/${controller.level.value}.gif',width: Get.width,height: Get.height,fit: BoxFit.fill,)),

      ],
    );
  }

}
