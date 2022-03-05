import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_page.dart';
import 'package:bybloom_tree/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'pages/forest_page/forest_page.dart';
import 'pages/mission_page/mission_page.dart';
import 'pages/tree_page/tree_page.dart';
import 'my_flutter_app_icons.dart';
import 'tutorial.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 아래 객체(WidgetsBinding)를 사용하면 build가 다 완료된 이후 콜백을 실행할 수 있다.
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      /// tutorial 안내 시작하는 코드
      /// arguments가 tutorial일 때 시작하도록, 개발할땐 다른 text로 바꿔놓자.
      /// 핫 리로드 할 때마다 떠서 빡친다
      if (Get.arguments == 'tutorialx'){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: '이제 시작해볼까요?',
          desc: '간단한 사용법 안내를 받아보시겠어요?',
          btnCancelText: '네!',
          btnCancelOnPress: () {
            Get.back();
            controller.showTutorial();
          },
          btnOkText: '괜찮아요',
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
      }
    });
    return SafeArea(
      child: Obx(()=>WillPopScope(
        /// 뒤로가기 버튼 누를 때, 나무 인덱스면 종료 팝업 뜨기 and 나머지 인덱스면 나무인덱스로 가기
        /// 종료 시의 좋은 사용자 경험 위해서. 아무것도 설정 안해놓으면 홈화면에서 실수로 뒤로가기 누르면 앱 꺼짐.
        onWillPop: controller.navigationBarIndex.value==0
          ?()=>controller.showExitPopup(context)
        :() async{
          controller.changeNavigationBarIndex(0);
          return false;
        },
        child: Scaffold(
          // extendBody - 화면 영역을 bottomNavigationBar와 앱바까지 확장시키는 것. - 높이 설정을 추가로 해줘야 함.
          extendBody: true,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: IndexedStack(
              index: controller.navigationBarIndex.value,
              children: [
                TreePage(),
                const MissionPage(),
                const ForestPage(),
                const ProfilePage()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0,1)
                )
              ],
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
              child: SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  elevation: 200,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(MyFlutterApp.tree, key: tutorialKey1,),
                        label: ''
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(MyFlutterApp.event_note,key: tutorialKey4,),
                        label: ''
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(MdiIcons.forest, key: tutorialKey5,),
                        label: ''
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(MdiIcons.folder, key: tutorialKey6,),
                        label: ''
                    )
                  ],
                  onTap: (index) {
                    controller.changeNavigationBarIndex(index);
                  },
                  selectedItemColor: Colors.black87,
                  unselectedItemColor: Colors.grey[300],
                  currentIndex: controller.navigationBarIndex.value,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  iconSize: 35,
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
