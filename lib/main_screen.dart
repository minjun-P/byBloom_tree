import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/other_tree_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'pages/mission_page.dart';
import 'pages/tree_page.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
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
      floatingActionButton: controller.navigationBarIndex==0
        ?FloatingActionButton(
          onPressed: (){
            Get.to(()=>OtherTreePage());
          },
        backgroundColor: Colors.lightGreenAccent,
          )
          :null,
    )
    );
  }
}
