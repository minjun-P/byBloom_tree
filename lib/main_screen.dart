import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'pages/forest_page/forest_page.dart';
import 'pages/mission_page/mission_page.dart';
import 'pages/storage_page/storage_page.dart';
import 'pages/tree_page/tree_page.dart';
import 'my_flutter_app_icons.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()=>Scaffold(
        // extendBody - 화면 영역을 bottomNavigationBar와 앱바까지 확장시키는 것. - 높이 설정을 추가로 해줘야 함.
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: IndexedStack(
            index: controller.navigationBarIndex.value,
            children: [
              TreePage(),
              MissionPage(),
              ForestPage(),
              StoragePage()
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              backgroundColor: Colors.red,
              items: const [
                BottomNavigationBarItem(icon: Icon(MyFlutterApp.tree), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(MyFlutterApp.event_note), label: ''),
                BottomNavigationBarItem(icon: Icon(MdiIcons.forest),label: ''),
                BottomNavigationBarItem(icon: Icon(MdiIcons.folder),label: '')
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
      )),
    );
  }
}
