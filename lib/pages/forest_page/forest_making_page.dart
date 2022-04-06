import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../tree_page/tree_controller.dart';
import 'forest_model.dart';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/forest_chat_room.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart' as tree;

class ForestMakingPage extends GetView<ForestController> {
  const ForestMakingPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    List<bool> checkbox=  List.filled(100,false);
    Get.put(ForestController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('숲 만들기',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),

          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 100,
              height: 100,
              child: ListTile(
                title: Text(
                  Get.find<TreeController>().currentUserModel!.friendList[index].name,
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
                leading: CircleAvatar(backgroundColor: Colors.lime,),
                trailing:Obx(()=>InkWell(
                 child:controller.checkbox[index].value?

                 Icon( Icons.check_circle, color: Colors.lightGreen):
                 Icon( Icons.check_circle, color: Colors.grey),
               onTap: (){ Get.find<ForestController>().checkbox[index].value=!Get.find<ForestController>().checkbox[index].value;},
            ))
                ),
              );



          },
          itemCount: Get.find<TreeController>().currentUserModel?.friendList.length,
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () {  },

      ),
      );



  }

}