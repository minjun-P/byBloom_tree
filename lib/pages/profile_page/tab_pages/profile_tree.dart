import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../tree_page/components/tree.dart';

class ProfileTree extends GetView<ProfileController> {
  const ProfileTree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
              future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text('error');
                }
                if (snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${snapshot.data!.data()!['name']}님의 나무는',style: TextStyle(fontSize: 22),),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(text: controller.profileComment[snapshot.data!.data()!['level']],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)),
                              TextSpan(text: '입니다',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                            ]
                        )
                    ),
                  ],
                );
                }),
          ],
        ),
        const SizedBox(height: 30,),
        ClipRRect(
            child: SizedBox(child: Tree()),
          borderRadius: BorderRadius.circular(40),
        )
      ],
    );
  }
}
