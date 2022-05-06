import 'package:bybloom_tree/DBcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';


/// 채팅방 UI
/// 대강 만들어 놓긴 했는데 보내는 버튼도 안 넣어놨고
/// 주환 너가 직접 만들어본 경험 있으니깐 여기는 직접 다루는게 더 편할 듯 해서 더 안 건드림
/// 채팅 목록은 forest_model에서 가져왔으.

class ForestChatRoom extends StatefulWidget {
  const ForestChatRoom({
    Key? key,
    required this.room
  }) : super(key: key);
  final types.Room room;
  @override
  State<StatefulWidget> createState() {
    return ForestChatState( room: room);
  }
}

class ForestChatState extends State<ForestChatRoom>{

  ForestChatState({
    Key? key,
    required this.room
  }) ;
  final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
  final types.Room room;
  /// 나중에 이 친구들 controller로 보내는게 깔끔할지도?
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScaffoldKey,
      endDrawer: buildCustomDrawer(child: ChatRoomDrawer(room: room),left: false),
      appBar: AppBar(
        leading: IconButton(onPressed:(){ Navigator.pop(context);} ,icon: const Icon(Icons.arrow_back),),
        title: Text(this.room.name??""),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [ IconButton(onPressed: (){
          _ScaffoldKey.currentState?.openEndDrawer();
        }, icon: const Icon(Icons.folder))],
      ),

      backgroundColor: const Color(0xffFAE7E2),
      body: StreamBuilder<types.Room>(
        initialData: this.room,
        stream: FirebaseChatCore.instance.room(this.room.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return SafeArea(
                bottom: false,
                child: Chat(
                  showUserAvatars: true,

                  customMessageBuilder: (types.CustomMessage s, {required int messageWidth} )=>
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Text('${DbController.to.currentUserModel.value.name}님이 오늘의 미션을 모두 완료하셨습니다',style: const TextStyle(color: Colors.black),),
                        width: Get.width*0.8,
                      ),


                  messages: snapshot.data ?? [],
                  showUserNames: true,
                  theme: const DefaultChatTheme(
                      userNameTextStyle: TextStyle(color:Colors.black),
                      backgroundColor: Color(0xffFAE7E2),
                      inputBackgroundColor: Color(0xffF0F0F0),
                      primaryColor:Colors.white,
                      inputTextColor: Colors.black,
                      secondaryColor: Colors.white,
                      inputTextStyle: TextStyle(color: Colors.black),
                      sentMessageBodyTextStyle: TextStyle(color:Colors.black)

                  ),

                  user: types.User(


                      id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                      firstName: DbController.to.currentUserModel.value.name,
                      lastName: "해",
                      imageUrl: DbController.to.currentUserModel.value.profileImage
                  ), onSendPressed:_handleSendPressed,
                ),
              );
            },
          );
        },
      ),
    );
  }






  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      this.room.id,
    );
    FirebaseFirestore.instance.collection('rooms').doc(room.id).update({"updatedAt":DateTime.now()});
    FirebaseFirestore.instance.collection('rooms').doc(room.id).update({"lastMessage":message.text});
    FirebaseAnalytics.instance.logEvent(name: 'sendmessage');
    Get.find<ForestController>().sendFCMformessage(room,DbController.to.currentUserModel.value.name, message.text);



  }
  Widget buildCustomDrawer({required Widget child, bool left=true}){
    return Drawer(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            //좌측이냐 아니냐 따라서 값 다르게 매기기
            topRight: left?const Radius.circular(30):Radius.zero,
            bottomRight: left?const Radius.circular(30):Radius.zero,
            topLeft: left?Radius.zero:const Radius.circular(30),
            bottomLeft: left?Radius.zero:const Radius.circular(30),
          )
      ),
      child: child,
    );
  }

}




/*
  @override
  Widget build(BuildContext context) {
     return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              /// 키보드가 생겨날 때, 화면이 그에 따라 움직일 수 있도록 만드는게 중요했다.
              /// 사용자경험 차원에서 보던 메시지가 계속 보여야 함. 여러방법을 찾아봤는데
              /// reverse를 활용하는 방법이 제일 좋음. 그래서 코드가 좀 더러워지긴 함.
              /// 원래는 이렇게 키보드가 생길 때 보이던 화면이 그대로 올라가질 않았음.
              reverse: true,
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index){
                /// 조건문으로 상대가 보낸 메시지와 내가 보낸 메시지를 구분해놓음
                // 상대가 보낸 메시지
                if (messages[messages.length-1-index].user !='나') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 20,
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(messages[messages.length-1-index].user,style: const TextStyle(color: Colors.grey, fontSize: 14),),
                            const SizedBox(height: 5,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  // overflow 방지 위해 with 명시적 설정
                                  constraints: BoxConstraints(maxWidth: Get.width*0.6),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(
                                      messages[messages.length-1-index].content),
                                ),
                                const SizedBox(width: 10,),
                                Text(messages[messages.length-1-index].getTime(),style: const TextStyle(color: Colors.grey, fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  // 내가 보낸 메시지
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(messages[messages.length-1-index].getTime(),style: const TextStyle(color: Colors.grey, fontSize: 12),),
                        const SizedBox(width: 10,),
                        Container(

                          constraints: BoxConstraints(maxWidth: Get.width*0.6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                              messages[messages.length-1-index].content),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            // border Radius 가 내가 원하는 데로 적용이 안됨. 나중에 수정이 필요함.
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 80
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: TextFormField(
                controller: textEditingController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  border: InputBorder.none
                ),
                // 알아서 line이 늘어나고 스크롤도 됨
                maxLines: null,
              ),
            ),
          )
        ],
      ),
    );
  }*/



class ChatRoomDrawer extends StatelessWidget {
  final types.Room room;
  const ChatRoomDrawer({Key? key, required this.room}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    List<types.User> userexceptme=deleteme(room.users, DbController.to.currentUserModel.value.name);
    return Container(
      color: Colors.white,
      height: Get.height,
      width: Get.width*0.3,
      child: SizedBox(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Container(
                padding:const EdgeInsets.all(30)
                ,child: Column(
                  children: [
                    const SizedBox(height: 100,),
                    const Text('숲구성원',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: Get.height*0.5,
                      child: userexceptme.isNotEmpty?ListView.builder(itemBuilder:
                   (BuildContext context, int index) {

                      return ListTile(
                     title: ((userexceptme[index].id=="unknown")?const Text("탈퇴한회원"):Text(
                     userexceptme[index].lastName??""+(userexceptme[index].firstName??""),
                     style: const TextStyle(
                     fontSize: 18
                     ),
                     )),
                     leading:Image.asset('assets/profile/${userexceptme[index].imageUrl}.png') ,
                      );
                      },itemCount: userexceptme.length): Container(
                        padding: const EdgeInsets.all(30),
                          child: const Text("아직구성원이없어요")),
                              )
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
           Row(
             children: [
            Container(
              padding: const EdgeInsets.only(top:20,bottom: 20),
              child: InkWell(
                  onTap: (){

                      Navigator.pop(context);
                      deleteroomfromuser(room.id);
                      Navigator.pop(context);


                  }, child:

              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const [
                    Icon(Icons.logout),
                    Text('방나가기'),
                  ],
                ),
              )),
            ),


          ],
        ),
      ]),
    )
    );
  }
}

List<types.User> deleteme(List<types.User> userList, String name){
  for(int i=0;i<userList.length;i++) {
    if ((userList[i].firstName != null) && (userList[i].lastName != null)) {
      if ((userList[i].firstName! + userList[i].lastName!) == name) {
        userList.removeAt(i);
        i--;
      }
    }
  }
  return userList;
}



deleteroomfromuser(String docid) {

      FirebaseFirestore.instance.collection("rooms").doc(docid).update({

        "userIds":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]) });
    }



