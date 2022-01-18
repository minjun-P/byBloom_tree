import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'pages/mission_page.dart';
import 'pages/tree_page.dart';
import 'CustomIcon.dart';
import 'my_flutter_app_icons.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      body: IndexedStack(
        index: controller.navigationBarIndex.value,
        children: [
          TreePage(),
          MissionPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(MyFlutterApp.tree ,color:Colors.lightGreen,), label: '',backgroundColor:Colors.lightGreen, ),
          BottomNavigationBarItem(
              icon: Icon(MyFlutterApp.event_note, color:Colors.lightGreen), label: '', backgroundColor:Colors.lightGreen ),
        ],
        onTap: (index) {
          controller.changeNavigationBarIndex(index);
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: controller.navigationBarIndex.value,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    ));
  }
}
