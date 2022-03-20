import 'package:bybloom_tree/auth/login_page.dart';
import 'package:bybloom_tree/auth/signup_page.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:bybloom_tree/pages/profile_page/profile_page.dart';
import 'package:bybloom_tree/pages/siginup_page/pages/signup_page1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import 'package:get/get.dart';

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
class FriendDrawer extends StatelessWidget {
  const FriendDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
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
            const Text('내 친구 목록', style: TextStyle(color: Colors.grey, fontSize: 14),),
            Row(
              children: const [
                Icon(Icons.search, color: Colors.grey,),
                Text('우리교회 검색',style: TextStyle(color: Colors.grey, fontSize: 14),)
              ],
            )
          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: List.generate(10, (index) {
              return ListTile(
                onTap: (){
                  /// db 연결 시, 각 친구에 맞는 프로필 페이지로 이동해야 할 듯.
                  Get.to(()=>const ProfilePage());
                },
                contentPadding: const EdgeInsets.all(10),
                dense: true,
                title: Row(
                  children: const [
                    Text('박민준',style: TextStyle(fontSize: 18),),
                    SizedBox(width: 30,),
                    Icon(Icons.message_outlined)
                  ],
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.redAccent[200],
                ),
              );
            })
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
    return Column(
      children: [
        const SizedBox(height: 20,),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            children: List.generate(20, (index) =>
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  height: 50,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(child: Text('+$index'), width: 30,),
                      const SizedBox(width: 10,),
                      const Flexible(
                        flex: 8,
                        child: Text(
                            '이상구님이 방문해 물을 주고 가셨습니다.',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      const Flexible(
                        flex: 1,
                          child: Text('2/2', style: TextStyle(color: Colors.grey,fontSize: 12),)
                      )
                    ],
                  ),
            )),
          ),
        ),
      ],
    );
  }
}

/// 우측 2번째 menu drawer
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.logout),
        onPressed: (){
          authservice.logout();
          Get.to(() => SignupPage1(),
              transition: Transition.rightToLeftWithFade);

        },
      ),
    );
  }
}

