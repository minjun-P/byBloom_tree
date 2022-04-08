import 'package:bybloom_tree/DBcontroller.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bybloom_tree/auth/login_page.dart';
import 'package:bybloom_tree/auth/signup_page.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:bybloom_tree/notification_controller.dart';
import 'package:bybloom_tree/pages/firend_page/friend_profile_page.dart';
import 'package:bybloom_tree/pages/profile_page/profile_page.dart';
import 'package:bybloom_tree/pages/siginup_page/pages/signup_page1.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../Profile/profilephoto.dart';
import '../../../auth/FriendAdd.dart';
import '../../../auth/FriendModel.dart';

Future<DocumentSnapshot> document= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
/// drawer는 모두 이 함수를 통해 만드는 것으로 통일 child 인수로 받음.
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

/// 좌측 친구 drawer - db 연결 필요
class FriendDrawer extends GetView<TreeController> {
  const FriendDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController s;
    return FirebaseAuth.instance.currentUser==null? Column(
     children:[ Text('로그인해주세요')]
    ):Column(
      children: [
        const SizedBox(height: 20,),
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState != ConnectionState.done) {

              return Text("wating");
            }
            return ListTile(
              dense: true,
              leading: (snapshot.data!.data() as Map<String,dynamic>)['imageUrl']==''? CircularProgressIndicator(): CircleAvatar(
                backgroundImage:
                ExtendedNetworkImageProvider((snapshot.data!.data() as Map<String,dynamic>)['imageUrl'],cache: true,scale:1),

                radius: 40,
              ),
              title: Text(
                  (snapshot.data!.data() as Map<String,dynamic>)['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              trailing: Text(
                '프로필 변경하기',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  decoration: TextDecoration.underline
                ),),
            );
          }
        ),
        const SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             InkWell(
          child:Text('내 친구 목록', style: TextStyle(color: Colors.grey, fontSize: 14),),
           onTap: () async {

             List<FriendModel>? friendlist=await findfriendwithcontact();
             showDialog(context: context, builder:(context){
               if(friendlist?.length==0){
                 return Card(
                   child:Text("아직 가입한 친구가없네요")
                 );
               }
               else return ListView.builder(
                   itemCount: friendlist?.length,
                   itemBuilder:(BuildContext context,int index){
                     return Card(
                         child:ListTile(
                       leading:
                           InkWell(
                           child:Text(friendlist![index].phoneNumber),
                           onTap:() async {
                             bool result=await AddFriend(friendlist[index].phoneNumber);
                             print('friendadded');

                           }
                           )
                             )



                     );
                   }
               );

             });

           }, ),
            /// s에 연락처연동해서 이미가입해있는 friendmodel들 list 받아왔으니까 친구추가화면 Ui만들어서 채워넣어
            Row(
              children: const [
                Icon(Icons.search, color: Colors.grey,),
                Text('친구 검색',style: TextStyle(color: Colors.grey, fontSize: 14),)
              ],
            )
          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),

          itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              Get.to(()=>FriendProfilePage(friendData: DbController.to.currentUserModel.friendList[index],));
            },
            child: ListTile(
              title: Text(
                DbController.to.currentUserModel.friendList[index].name,
                  style: TextStyle(
                    fontSize: 18
                  ),
              ),
              leading: CircleAvatar(backgroundColor: Colors.lime,),
              trailing: Icon(MdiIcons.messageProcessingOutline,color: Colors.grey.shade500,),
            ),
          );
          },
            itemCount: DbController.to.currentUserModel.friendList.length,
          ),
        )
      ],
    );
  }
}

/// 우측 첫번째 알림 drawer - db 연결 필요
class NoticeDrawer extends StatelessWidget {
  const NoticeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting){
        return CircularProgressIndicator();
        }
        // user document 를 map 으로 변환
        Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
        if (data['waterFrom']==null){
          return Text('아직 아무도 물을 주지 않았어요 ㅠ');
        } else {
          List list = data['waterFrom'];
          return ListView(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('누군가 물을 주고 간 기록입니다!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              ...list.map((element){
              //  element 는 개별 Map - each 물 준 기록
                String name = element['name']??'hi';
                Timestamp timestamp = element['when'] ;
                DateTime date = timestamp.toDate();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                          TextSpan(text:'님이 물을 주고 가셨어요!!')
                        ]
                      )
                    ),
                    Text('${date.month}/${date.day}', style: TextStyle(color: Colors.grey, fontSize: 14),)
                  ],
                ),
              );
            }
            ).toList(),
            ]
          );
        }
      },
    );
  }
}

/// 우측 2번째 menu drawer
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height,
      child: SizedBox(
        width: Get.width*0.4,
        child: Column(

          children: [
            SizedBox(
              height: 50,
            ),
       
            Container(
              padding: EdgeInsets.only(top:50,bottom: 20),
              child: InkWell(
                  onTap: (){
                authservice.logout();
                Get.to(() => SignupPage1(),
                    transition: Transition.rightToLeftWithFade);

              }, child:

              Column(
                children: [
                  Icon(Icons.logout),
                  Text('로그아웃'),
                ],
              )),
            ),
            Container(
              padding: EdgeInsets.only(top:20,bottom: 20),
              child: InkWell(
                  onTap: (){

                   showresignPopup(context);


                  }, child:

              Column(
                children: [
                  Icon(Icons.no_accounts),
                  Text('회원탈퇴'),
                ],
              )
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:20,bottom: 20),
              child: Obx(()=>InkWell(
                  onTap: (){
                   Get.find<NotificationController>().pushalarmtrue.value=!Get.find<NotificationController>().pushalarmtrue.value;
                   Get.find<NotificationController>().prefs.setBool('pushalarm', Get.find<NotificationController>().pushalarmtrue.value);
                   print(Get.find<NotificationController>().pushalarmtrue.value);
                   }, child:

              Column(
                children: [
                  Icon(Icons.doorbell,
                    color: Get.find<NotificationController>().pushalarmtrue.value ? Colors.black:Colors.grey,),
                  Text('푸쉬알람변경'),
                ],
              ))
      ),
            )


          ],
        ),
      ),
    );
  }
}
Future<bool> showresignPopup(context) async {
  return await AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      title: '정말탈퇴하시겠어요?',
      desc: '저희는 당신의 신앙 도우미 bybloom이었습니다. 다음에 또 놀러오세요!',
      body: FractionallySizedBox(
        widthFactor: 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('정말탈퇴하시겠어요?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            Text('떠나신다니 아쉽습니다. 저희는 당신의 신앙 도우미 bybloom 이었습니다. 다음에 또 놀러오세요!')
          ],
        ),
      ),
      btnOkText: '아니오',
      btnOkOnPress: () {
        Get.back(closeOverlays: true);
      },
      btnCancelText: '네',
      btnCancelOnPress: () {

        FirebaseChatCore.instance.deleteUserFromFirestore(
          DbController.to.currentUserModel.uid
        );
        Get.toNamed('/login');

      }
  ).show();
}
