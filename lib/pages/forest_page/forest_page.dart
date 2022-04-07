import 'dart:math';
import 'package:bybloom_tree/pages/forest_page/forest_making_page.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'forest_model.dart';
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
        actions: [IconButton(onPressed:(){

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
        stream: FirebaseChatCore.instance.rooms(orderByUpdatedAt: false),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('아직 가입한 숲이없어요'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

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
              ])),
                      Text(room.name ?? ''),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            Text('방제목',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            Text(
                              '최근메시지',
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
