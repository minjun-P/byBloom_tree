import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_B/not_selection_answer.dart';
import 'package:bybloom_tree/pages/mission_page/pages/type_B/selection_answer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriorMissionB extends GetView<MissionController>{
  const PriorMissionB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('지난 나눔 보기',style: TextStyle(color: Colors.grey.shade500),),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('missions').orderBy('day',).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Text('에러남');
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            // today doc 빼고, 오늘 이전인 doc 만 필터링
            List<QueryDocumentSnapshot> filteredDocs = docs.where((element) {
              if (element.id=='today'){
                return false;
              } else {
                int num = int.parse(element.id.replaceFirst('day', ''));
                return num<controller.day.value;
              }
            }).toList();
            /**
            List<QueryDocumentSnapshot> filteredDocs = docs.where((element) {
              int num = int.parse(element.id.replaceFirst('day', ''));
              return num<controller.day.value;
            }).toList();*/
            return ListView(
              children: filteredDocs.map((document){

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(1,1)
                      )
                    ]
                  ),
                  child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                    future: FirebaseFirestore.instance.collection('missions').doc(document.id)
                        .collection('category').doc('B').get(),
                    builder: (context, snapshot){
                      if (snapshot.hasError){
                        return Text('에러남');
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      return GestureDetector(
                          child: Text(snapshot.data!.data()!['제목'],style: TextStyle(fontSize: 19,color: Color(0xff4A4A4A)),),
                        onTap: (){
                          if (snapshot.data!.data()!['객관식']){
                            Get.to(()=>SelectionAnswer(prior: true,missionData: snapshot.data!.data()!,day: int.parse(document.id.replaceFirst('day', '')),));
                          } else {
                            Get.to(()=>NoSelectionAnswer(prior: true, missionData: snapshot.data!.data()!,day: int.parse(document.id.replaceFirst('day', '')),));
                          }
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        )
      ),
    );
  }
}
