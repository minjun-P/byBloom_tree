import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


/// 우측 첫번째 알림 drawer - db 연결 필요
class NoticeDrawer extends StatelessWidget {
  const NoticeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        // user document 를 map 으로 변환
        Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
        if (data['waterFrom']==null){
          return const Text('');
        } else {
          List list = data['waterFrom'];
          return ListView(
              children: [
                const SizedBox(height: 20,),
                ...list.map((element){
                  //  element 는 개별 Map - each 물 준 기록
                  String name = element['name'];
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
                                  TextSpan(text: name, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                  const TextSpan(text:'님이 물을 주고 가셨어요!!')
                                ]
                            )
                        ),
                        Text('${date.month}/${date.day}', style: const TextStyle(color: Colors.grey, fontSize: 14),)
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