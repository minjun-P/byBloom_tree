import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/Forest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'drawer.dart';

import 'pages/mission_page/mission_page.dart';
import 'pages/tree_page.dart';
import 'my_flutter_app_icons.dart';

class MainScreen extends GetView<MainController> {
  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360,690),
      context: context,
      minTextAdapt: true,
      orientation: Orientation.portrait);

    return Obx(()=>Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      endDrawer:MainDrawer(),
      body: Stack(
        children:
        <Widget>[

          IndexedStack(
        index: controller.navigationBarIndex.value,
        children: [
          TreePage(),
          MissionPage(),
          ForestPage()
        ],
      ),
          Positioned(
              top:40,
              right: 10,
              child: IconButton(
                icon:Icon(Icons.menu),
                iconSize: 30,
                onPressed: (){
                  _scaffoldKey.currentState!.openEndDrawer();
                },)),]
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
        child: SizedBox(
          height: 80,
          child: Expanded(
            flex:1,
            child:
          BottomNavigationBar(

            backgroundColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(MyFlutterApp.tree), label: '',backgroundColor:Colors.lightGreen, ),
              BottomNavigationBarItem(
                  icon: Icon(MyFlutterApp.event_note), label: '', backgroundColor:Colors.lightGreen ),
              BottomNavigationBarItem(icon: Icon(Icons.message),label: '', backgroundColor:Colors.lightGreen )
            ],
            onTap: (index) {
              controller.changeNavigationBarIndex(index);
            },
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.white,
            currentIndex: controller.navigationBarIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 35,
          ),
          )
        ),
      ),
    ));
  }
}
