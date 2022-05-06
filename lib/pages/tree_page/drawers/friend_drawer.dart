import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/firend_page/friend_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../firend_page/friend_add_page.dart';
import '../tree_controller.dart';

/// 좌측 친구 drawer - db 연결 필요
class FriendDrawer extends GetView<TreeController> {
  const FriendDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        // 나의 프로필
        Obx(()=>
          ListTile(
            dense: true,
            leading: DbController.to.currentUserModel.value.profileImage==''
                ?const CircularProgressIndicator()
                :Image.asset(

                'assets/profile/${DbController.to.currentUserModel.value.profileImage}.png'
              ,width: 80,height: 80,)

            ,
            title: Text(DbController.to.currentUserModel.value.name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),

          ),
        ) ,

        const SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child:Text('내 친구 목록', style: TextStyle(color: Colors.grey, fontSize: 14),),
              onTap: () async {

                List<FriendModel>? friendlist=await findfriendwithcontact(DbController.to.currentUserModel.value.phoneNumber);
                showDialog(context: context, builder:(context){
                  if(friendlist?.length==0){
                    return Card(
                        child:Text("아직 가입한 친구가없네요")
                    );
                  }
                  else {
                    return ListView.builder(
                      itemCount: friendlist?.length,
                      itemBuilder:(BuildContext context,int index){
                        return Card(
                            child:ListTile(
                                leading:
                                InkWell(
                                    child:Text(friendlist![index].phoneNumber),
                                    onTap:() async {
                                      bool result=await AddFriend(friendlist[index]);

                                    }
                                )
                            )



                        );
                      }
                  );
                  }

                });

              }, ),
            /// s에 연락처연동해서 이미가입해있는 friendmodel들 list 받아왔으니까 친구추가화면 Ui만들어서 채워넣어

            GestureDetector(
              onTap: (){

<<<<<<< HEAD
              Get.to(()=>const FriendAddPage());

=======
                Get.to(()=>FriendAddPage());
>>>>>>> parent of 6cf3431 (Merge branch 'main' of https://github.com/minjun-P/byBloom_tree)
              },

              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey,),
                  Text('친구 검색',style: TextStyle(color: Colors.grey, fontSize: 14),)
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 20,),
        /// 친구 목록 창
        Expanded(
          child: Obx(()=>
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: DbController.to.currentUserModel.value.friendList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Get.to(()=>FriendProfilePage(friendData: DbController.to.currentUserModel.value.friendList[index],));
                  },
                  child: ListTile(
                    title: Text(
                      DbController.to.currentUserModel.value.friendList[index].name,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    leading: Image.asset('assets/profile/${DbController.to.currentUserModel.value.friendList[index].profileImage}.png'),
                    trailing: Icon(MdiIcons.messageProcessingOutline,color: Colors.grey.shade500,),
                  ),
                );
              },

            ),
          ),
        )
      ],
    );
  }
}