import 'package:bybloom_tree/auth/authservice.dart';

import '../siginup_page/pages/signup_page1.dart';
import 'package:bybloom_tree/pages/tree_page/components/tree_status.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/drawers.dart';
import 'components/tree.dart';
import 'package:bybloom_tree/tutorial.dart';

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
    var a = precacheImage(const AssetImage('assets/tree/background_1.jpg'), context);
    return Scaffold(
      key: _outsideScaffoldKey,
      appBar: AppBar(
        centerTitle: true,

        title: InkWell(
        child: const Text('bybloom',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
        onTap: (){authservice.logout();
        Get.toNamed('./first');


        },
        ),
        /// 친구 목록 drawer - db 연결 필요 - 하단 Scaffold의 drawer 파라미터 참조
        leading: IconButton(
          key: tutorialKey3,
          icon:const Icon(Icons.person),
          onPressed: (){
            _insideScaffoldKey.currentState?.openDrawer();
            },
        ),
        actions: [
          /// 알림 목록 drawer - db 연결 필요 - 하단 Scaffold의 endDrawer 파라미터 참조
          IconButton(
            key: tutorialKey2,
            icon: const Icon(CupertinoIcons.bell),
            onPressed: (){
              _insideScaffoldKey.currentState?.openEndDrawer();
            },
          ),
          // 아직 용도가 없는 메뉴 drawer
          IconButton(
            icon: const Icon(Icons.menu),
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
            )
          ],
        )
      )
    );
  }
}
