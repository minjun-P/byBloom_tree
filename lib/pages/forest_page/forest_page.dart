import 'dart:core';
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_making_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'pages/forest_chat_room.dart';



/// 숲 페이지 - 카톡처럼 클릭하면 내부 채팅방 들어가짐.
/// DB 연결할 껀덕지가 제일 많은 곳이 아닐까 싶음. 내부 채팅방은 아마 더...
/// 지금은 임시로 forest_model 페이지에 만들어놓은 데이터를 가져다 대강 구현해놓음
/// 그 데이터를 db에서 불러온 값으로 대체하면 될 듯 하다.
/// 채팅 UI는 너가 더 잘 알테니 알아서 수정해도 될 듯.
class ForestPage extends GetView<ForestController> {
  const ForestPage({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {

    Get.put(ForestController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('숲',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        actions: [Text('숲만들기'),IconButton(onPressed:(){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForestMakingPage()),
            );


        }, icon: Icon(
          Icons.add_box))],
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<types.Room>>(

        stream:   rooms(orderByUpdatedAt: true),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
            child:Text("아직 가입한 숲이없어요"));

          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];
              String name="";
              String imageUrl="";
              List colorindex=[];
              if(room.type==types.RoomType.group) {
               colorindex= controller.colorFromString(room);
              }
              if(room.type==types.RoomType.direct){
                String uid="";
                if (room.users.length==1) {
                   uid= "알수없음";
                  name="알수없음";
                  imageUrl="f_2";
                }
                else if (DbController.to.currentUserModel.value.uid==room.users[0].id) {
                  uid=room.users[1].id;}
                 DbController.to.currentUserModel.value.friendList.forEach((element) {
                    if(element.uid==uid){
                      name=element.name;
                      imageUrl=element.profileImage;
                    }
                 });
                }






              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForestChatRoom(
                        room: room,
                      ),
                    ),
                  );
                },
                child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                height: 120,
                  color: Colors.white,

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

              room.type==types.RoomType.group ? Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              // 색 값 따로 다 설정하기 귀찮아서 그냥 랜덤으로 정해지도록 임시 설정함함
              Color.fromRGBO(colorindex[0], colorindex[1], colorindex[2], 1),
              Color.fromRGBO(colorindex[3], colorindex[4], colorindex[5], 1)
              ]
              ),
              boxShadow: const[
              BoxShadow(color: Colors.grey,offset: Offset(3,3),blurRadius: 3)
              ])):
              Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(image: AssetImage('assets/profile/${imageUrl}.png')),
                      ))  ,
                      const SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            Text(name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            Obx(
                              ()=> Text(
                               controller.lastMessages[room.id]!=null?controller.lastMessages[room.id]:"최근메시지없",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (room.updatedAt!=null)?
                            '${((DateTime.now().millisecondsSinceEpoch-room.updatedAt!.floor())/60000).floor().toString()}분전':'방금',
                            style: const TextStyle(color: Colors.grey,fontSize: 13),),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            alignment: Alignment.center,
                            child: Text("0",style: const TextStyle(color: Colors.white,fontSize: 14),),
                          )
                        ],
                      )
                    ],
                  ),
              )
              );
            },
          );
        },
      ),
      /*ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: forestList.length,
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              Get.to(()=>ForestChatRoom(room:));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              // 색 값 따로 다 설정하기 귀찮아서 그냥 랜덤으로 정해지도록 임시 설정함함
                              Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1),
                              Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1)
                            ]
                        ),
                      boxShadow: const[
                        BoxShadow(color: Colors.grey,offset: Offset(3,3),blurRadius: 3)
                      ]
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Text(forestList[index].name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                        Text(
                            forestList[index].latestMessage.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        forestList[index].latestMessage.getTime(),
                        style: const TextStyle(color: Colors.grey,fontSize: 13),),
                      const SizedBox(height: 5,),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Text(forestList[index].unreadCount.toString(),style: const TextStyle(color: Colors.white,fontSize: 14),),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      )*/
    );

  }

}
Stream<List<types.Room>> rooms({bool orderByUpdatedAt = false}) {
  final fu = FirebaseAuth.instance.currentUser;

  if (fu == null) {

    return const Stream.empty();
  }
  final collection =FirebaseFirestore.instance.
      collection("rooms")
      .where('userIds', arrayContains: fu.uid)
      .orderBy('updatedAt', descending: true);

   Stream<List<types.Room>> s=collection.snapshots().asyncMap(
        (query) => processRoomsQuery(
      fu,
      FirebaseFirestore.instance,
      query,
      "users",
    ),
  );
   Future<int> length=s.length;

   return s;
}

Future<List<types.Room>> processRoomsQuery(
    User firebaseUser,
    FirebaseFirestore instance,
    QuerySnapshot<Map<String, dynamic>> query,
    String usersCollectionName,
    ) async {
  final futures = query.docs.map(
        (doc) => processRoomDocument(
      doc,
      firebaseUser,
      instance,
      usersCollectionName,
    ),
  );
  return await Future.wait(futures);
}

/// Returns a [types.Room] created from Firebase document
Future<types.Room> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    FirebaseFirestore instance,
    String usersCollectionName,
    ) async {
  final data = doc.data()!;

  data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
  data['id'] = doc.id;
  data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

  var imageUrl = data['imageUrl'] as String?;
  var name = data['name'] as String?;
  final type = data['type'] as String;
  final userIds = data['userIds'] as List<dynamic>;
  final userRoles = data['userRoles'] as Map<String, dynamic>?;
  final users = await Future.wait(
    userIds.map(
          (userId) => fetchUser(
        instance,
        userId as String,
        usersCollectionName,
        role: userRoles?[userId] as String?,
      ),
    ),
  );

  if (type == types.RoomType.direct.toShortString()) {
    try {
      final otherUser = users.firstWhere(
            (u) => u['id'] != firebaseUser.uid,
      );

      imageUrl = imageUrl;
      name = '${otherUser['firstName'] ?? ''} ${otherUser['lastName'] ?? ''}'
          .trim();
    } catch (e) {
      // Do nothing if other user is not found, because he should be found.
      // Consider falling back to some default values.
    }
  }

  data['imageUrl'] = imageUrl;
  data['name'] = name;
  data['users'] = users;

  if (data['lastMessages'] != null) {
    final lastMessages = data['lastMessages'].map((lm) {
      final author = users.firstWhere(
            (u) => u['id'] == lm['authorId'],
        orElse: () => {'id': lm['authorId'] as String},
      );

      lm['author'] = author;
      lm['createdAt'] = lm['createdAt']?.millisecondsSinceEpoch;
      lm['id'] = lm['id'] ?? '';
      lm['updatedAt'] = lm['updatedAt']?.millisecondsSinceEpoch;

      return lm;
    }).toList();

    data['lastMessages'] = lastMessages;
  }

  return types.Room.fromJson(data);
}
