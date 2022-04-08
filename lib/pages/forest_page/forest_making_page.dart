import 'dart:core';
import 'dart:math';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:core';
import '../tree_page/tree_controller.dart';
import 'forest_model.dart';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/forest_chat_room.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart' as tree;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bybloom_tree/auth/User.dart';

List <bool> checkbox= List.filled(100,false);
List<types.User> userlist=[];
class ForestMakingPage extends StatefulWidget {
  const ForestMakingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return  Forest_making_state();
  }



}

class Forest_making_state extends State<ForestMakingPage> {

@override
  Widget build(BuildContext context) {
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
                trailing:InkWell(
                 child:checkbox[index]?

                 Icon( Icons.check_circle, color: Colors.lightGreen):
                 Icon( Icons.check_circle, color: Colors.grey),
               onTap: () async {
                   setState(()  {
                     print(checkbox);
                     checkbox[index]=!checkbox[index];

                   });
                    if(checkbox[index]==true){
                     String? uid=await finduidFromPhone(Get.find<TreeController>().currentUserModel!.friendList![index].phoneNumber);
                     userlist.add(types.User(id:uid!));}
                   if(checkbox[index]==false){
                     String? uid=await finduidFromPhone(Get.find<TreeController>().currentUserModel!.friendList![index].phoneNumber);
                     userlist.remove(types.User(id:uid!));}
                   ;
                   }
                    )
            )
            );
                   },





          itemCount: Get.find<TreeController>().currentUserModel?.friendList.length,
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          checkbox.fillRange(0, 99,false);
          types.Room room2= await FirebaseChatCore.instance.createGroupRoom(name: "", users: userlist);
          Navigator.of(context).push(

            MaterialPageRoute(
              builder: (context) => ForestChatRoom(
                room: room2,
              ),
            ),
          );
        },

      ),
      );



  }

}