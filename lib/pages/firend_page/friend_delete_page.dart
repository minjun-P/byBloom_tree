import 'dart:core';
import 'dart:math';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:core';
import '../tree_page/tree_controller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart' as tree;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bybloom_tree/auth/User.dart';

List <bool> checkbox= List.filled(100,false);
List<types.User> userlist=[];
TextEditingController s= TextEditingController(
);
class FriendDeletingPage extends StatefulWidget {
  const FriendDeletingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return  Friend_deleting_state();
  }



}

class Friend_deleting_state extends State<FriendDeletingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('친구삭제',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        toolbarHeight: 50,
      ),
      backgroundColor: Colors.white,
      body:
      Column(

        children: [
          SizedBox(
            height: 30,
          ),


          Container(
            height: Get.height*0.6,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: 100,
                    height: 100,
                    child: ListTile(
                        title: Text(
                          DbController.to.currentUserModel.value.friendList[index].name,
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        leading: CircleAvatar(backgroundColor: Colors.lime,),
                        trailing:InkWell(


                           child: Icon( MdiIcons.delete),

                            onTap: ()  {
                                  deleteFriend(DbController.to.currentUserModel.value.friendList[index]) ;
                                  Navigator.pop(context);
                            }
                        )
                    )
                );
              },





              itemCount: DbController.to.currentUserModel.value.friendList.length,
            ),
          ),
        ],
      ),


    );



  }

}