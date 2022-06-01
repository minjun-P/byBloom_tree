import 'dart:core';
import 'dart:math';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/forest_chat_room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:bybloom_tree/auth/User.dart';

List <bool> checkbox= List.filled(100,false);
List<types.User> userlist=[];
TextEditingController s= TextEditingController(
);
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
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        actions: [
          TextButton(onPressed: () async {

          checkbox.fillRange(0, 99,false);
          String gradcolor1=(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString();
          String gradcolor2=(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString()+","+(142+Random().nextInt(113)).toString();
          String imageindex=gradcolor1+","+gradcolor2;

          types.Room room2= await FirebaseChatCore.instance.createGroupRoom(name: s.text, users: userlist, imageUrl:imageindex);

          Navigator.pop(context);

          Navigator.of(context).push(

            MaterialPageRoute(
              builder: (context) => ForestChatRoom(
                room: room2,
              ),
            ),
          );
        }, child: const Text('숲만들기',style: TextStyle(color: Colors.grey),))],
        title: const Text('숲에 함께할 친구고르기',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

              Container(
                padding:const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                  border: Border.fromBorderSide(BorderSide(color:Colors.grey ,style: BorderStyle.solid,width: 3),
                  )
                ),
                width: Get.width*0.7,
                  child: TextFormField(
                    decoration: const InputDecoration(

                      labelText: "숲의 이름을 지어주세요"
                    ),
                    controller: s,
                  )),
              const SizedBox(
                height: 50,
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
                           child:checkbox[index]?

                           const Icon( Icons.check_circle, color: Colors.lightGreen):
                           const Icon( Icons.check_circle, color: Colors.grey),
                         onTap: () async {
                             setState(()  {
                               checkbox[index]=!checkbox[index];

                             });
                              if(checkbox[index]==true){
                               String? uid=await finduidFromPhone(DbController.to.currentUserModel.value.friendList[index].phoneNumber);
                               userlist.add(types.User(id:uid!));}
                             if(checkbox[index]==false){
                               String? uid=await finduidFromPhone(DbController.to.currentUserModel.value.friendList[index].phoneNumber);
                               userlist.remove(types.User(id:uid!));}
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