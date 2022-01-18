import 'package:bybloom_tree/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'pages/mission_page.dart';
import 'pages/tree_page.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_mosaic), label: ''),
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
