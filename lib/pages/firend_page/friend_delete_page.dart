import 'dart:core';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
          const SizedBox(
            height: 30,
          ),


          SizedBox(
            height: Get.height*0.6,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    width: 100,
                    height: 100,
                    child: ListTile(
                        title: Text(
                          DbController.to.currentUserModel.value.friendList[index].name,
                          style: const TextStyle(
                              fontSize: 18
                          ),
                        ),
                        leading: const CircleAvatar(backgroundColor: Colors.lime,),
                        trailing:InkWell(


                           child: const Icon( MdiIcons.delete),

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