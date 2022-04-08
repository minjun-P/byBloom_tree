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
          title: Text('지난 나눔 미션'),
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
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(1,1)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.id,style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Colors.grey),),
                      const Divider(thickness: 2,),
                      FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                        future: FirebaseFirestore.instance.collection('missions').doc(document.id)
                            .collection('category').doc('B').get(),
                        builder: (context, snapshot){
                          if (snapshot.hasError){
                            return Text('에러남');
                          }
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.data()!['제목']),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                  onPressed: (){
                                    if (snapshot.data!.data()!['객관식']){
                                      Get.to(()=>SelectionAnswer(prior: true,missionData: snapshot.data!.data()!,day: int.parse(document.id.replaceFirst('day', '')),));
                                    } else {
                                      Get.to(()=>NoSelectionAnswer(prior: true, missionData: snapshot.data!.data()!,day: int.parse(document.id.replaceFirst('day', '')),));
                                    }
                                  },
                                  child: Text('보러가기',style: TextStyle(color: Colors.black),),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  fixedSize: Size(110,40)
                                ),

                              )
                            ],
                          );
                        },
                      )
                    ],
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
