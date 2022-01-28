import 'package:bybloom_tree/pages/other_tree_page.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TreePage extends GetView<TreeController> {
  const TreePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(TreeController());
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/tree_background2.png'),
                  fit: BoxFit.fill
              )
          ),
        ),
        Positioned(
          bottom: 80,
          child: ShaderMask(
              shaderCallback: (Rect bound){
                return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white,Colors.transparent],
                    stops: [0.5,0.75]
                ).createShader(bound);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset('assets/tree_main.png',width: 400,fit: BoxFit.fitWidth,)
          ),
        ),
        Positioned(
          left: 30,
          top: 40,
          child: GestureDetector(
            onTap: (){
              controller.animateWateringIcon();
            },
            child: RotationTransition(
              turns: controller.wateringIconController,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white,width: 2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(MdiIcons.wateringCan,size: 50,color: Colors.white)),

            ),
          ),
        ),
        Positioned(
          top: 40,
            child: FadeTransition(
              opacity: controller.rainAnimation,
                child: Image.asset('assets/rain.gif')
            )
        )
      ],
    )
      ;
  }
}
