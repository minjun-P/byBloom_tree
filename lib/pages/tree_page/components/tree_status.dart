import 'package:bybloom_tree/main.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Stream<DocumentSnapshot> documentStream= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots();

class TreeStatus extends GetView<TreeController> {
  const TreeStatus({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// 임시 물 받기 아이콘
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: const Icon(
                  Icons.check_circle_outline,
                color: Colors.white,
                size: 60,
              ),
              onPressed: (){
                controller.show();
              },),
          ),
          const SizedBox(height: 10,),
          /// 경험치 바, 어떻게 코드 짤지 고민을 좀 더 해보겠음
          Container(
            width: 500,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
            alignment: Alignment.centerLeft,
            child: StreamBuilder<DocumentSnapshot>(
              stream: documentStream,
              builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.hasError){
                  return Text('Something Went wrong');
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return LinearProgressIndicator();
                }

                Map<String, dynamic>? data= snapshot.data?.data() as Map<String, dynamic>?;
                if(data !=null){
                  data=data  as Map<String,dynamic>;


                }
                return AnimatedContainer(

                  width:data!['exp'].toDouble(),
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green.shade100
                  ),
                );
              }
            ),
          ),

        ],
      ),
    );
  }


}
