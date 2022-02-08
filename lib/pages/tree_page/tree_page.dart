import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'components/drawers.dart';
import 'components/tree.dart';

class TreePage extends GetView<TreeController> {
  TreePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _insideScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _outsideScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(TreeController());
    return Scaffold(
      key: _outsideScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('bybloom',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
        leading: IconButton(
          icon:Icon(Icons.person),
          onPressed: (){
            _insideScaffoldKey.currentState?.openDrawer();
            },
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell),
            onPressed: (){
              _insideScaffoldKey.currentState?.openEndDrawer();
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){
              _outsideScaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: MenuDrawer(),
      body: Scaffold(
        // drawer 세팅 - key는 drawer 컨트롤용
        key: _insideScaffoldKey,
        drawer: buildCustomDrawer(child: FriendDrawer()),
        endDrawer: buildCustomDrawer(child: NoticeDrawer(),left: false),

        // 나무 페이지 화면을 Tree 객체로 통합하여 관리
          // scale이 무슨 의미인지는 잘 모르겠음.
        body: Tree(scale: 0.5,)
      )
    );
  }
}

/**
    Positioned(
    bottom: 80,
    child: ShaderMask(
    shaderCallback: (Rect bound){
    return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white,Colors.transparent],
    stops: [0.5,0.75]
    ).createShader(bound);
    },
    blendMode: BlendMode.dstIn,
    child: Image.asset('assets/tree_main.png',width: 400,fit: BoxFit.fitWidth,)
    ),
    )

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
    child: const Icon(MdiIcons.wateringCan,size: 50,color: Colors.white)),

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
    */
