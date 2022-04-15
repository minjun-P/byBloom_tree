import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import 'package:bybloom_tree/pages/tree_page/components/waterToLimit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mission_page/mission_controller.dart';
import '../siginup_page/pages/signup_page_main.dart';
import 'package:bybloom_tree/pages/tree_page/components/tree_status.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/tree.dart';
import 'package:bybloom_tree/tutorial.dart';

import 'drawers/friend_drawer.dart';
import 'drawers/menu_drawer.dart';
import 'drawers/notice_drawer.dart';

/// 나무 페이지
class TreePage extends GetView<TreeController> {
  TreePage({Key? key}) : super(key: key);
  // Scaffold 2개를 겹쳐서 사용했다. 각 Scaffold를 제어하기 위한 globalKey
  // 2개를 겹쳐 사용한 이유는 drawer를 앱 바 하단 영역에만 보이게 하도록 하려고!
  final GlobalKey<ScaffoldState> _insideScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _outsideScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(TreeController());
    // 임시
    Get.put(MissionController());
    return Scaffold(
      key: _outsideScaffoldKey,
      appBar: AppBar(
        centerTitle: true,

        title: GestureDetector(
          onTap: (){print(DbController.to.currentUserModel.toJson());},
          child: Image.asset(
            'assets/title.png'
          ),
        ),
        /// 친구 목록 drawer - db 연결 필요 - 하단 Scaffold의 drawer 파라미터 참조
        leading: IconButton(
          key: tutorialKey3,
          icon: Image.asset('assets/friend_icon.png',color: Colors.grey,),
          onPressed: (){
            _insideScaffoldKey.currentState?.openDrawer();
            },
        ),
        actions: [
          /// 알림 목록 drawer - db 연결 필요 - 하단 Scaffold의 endDrawer 파라미터 참조
          IconButton(
            key: tutorialKey2,
            icon: Image.asset('assets/bell_icon.png'),
            onPressed: (){
              _insideScaffoldKey.currentState?.openEndDrawer();
            },
          ),
          // 아직 용도가 없는 메뉴 drawer
          IconButton(
            icon: Image.asset('assets/menu_icon.png'),
            onPressed: (){
              _outsideScaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      /// 3개의 drawer는 모두 tab_pages 폴더의 drawers 파일에서 확인 가능
      endDrawer: const MenuDrawer(),
      body: Scaffold(
        key: _insideScaffoldKey,
        drawer: buildCustomDrawer(child: const FriendDrawer()),
        endDrawer: buildCustomDrawer(child: const NoticeDrawer(),left: false),


        // 나무 페이지 화면을 Tree 객체로 통합하여 관리
          // scale 작동 원리가 뭔지 잘 모르겠음.
        body: Stack(
          alignment: Alignment.center,
          children: const [
            Tree(),
            Positioned(
              bottom: 20,
                left: 10,
                right: 10,
                child: TreeStatus()
            ),

          ],
        )
      )
    );
  }
  Widget buildCustomDrawer({required Widget child, bool left=true}){
    return Drawer(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            //좌측이냐 아니냐 따라서 값 다르게 매기기
            topRight: left?const Radius.circular(30):Radius.zero,
            bottomRight: left?const Radius.circular(30):Radius.zero,
            topLeft: left?Radius.zero:const Radius.circular(30),
            bottomLeft: left?Radius.zero:const Radius.circular(30),
          )
      ),
      child: child,
    );
  }
}
