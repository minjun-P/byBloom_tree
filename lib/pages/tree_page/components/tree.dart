import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tree extends StatelessWidget {
  const Tree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffF6F4DD), Color(0xffFFF8A5), Color(0xffF6F4DD),Color(0xffFFF8A5),Color(0xffF6F4DD),]
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/tree_sample.png',width: Get.width,fit: BoxFit.fitWidth,)
        ],
      ),

    );
  }
}
