import 'package:bybloom_tree/pages/other_tree_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tree_background2.png'),
            fit: BoxFit.fill
          )
        ),
      alignment: Alignment(0,0.6),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bound){
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white,Colors.transparent],
                stops: [0.5,0.75]
              ).createShader(bound);
            },
              blendMode: BlendMode.dstIn,
              child: Image.asset('assets/tree_main.png',width: 500,fit: BoxFit.fitWidth,)
          ),

        ]),
    );
  }
}
