import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWorship extends GetView<ProfileController> {
  const ProfileWorship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<List>(
            stream: controller.getWorshipStream(),
            builder: (context, snapshot) {

              if (snapshot.hasError){
                return const Text('에러발생');
              }

              if (snapshot.connectionState==ConnectionState.waiting){
                return const Text('로딩중');
              }
              List sortedList = snapshot.data!..sort((a,b){
                Timestamp timestampA = a['createdAt'] as Timestamp;
                Timestamp timestampB = b['createdAt'] as Timestamp;
                DateTime dateA = timestampA.toDate();
                DateTime dateB = timestampB.toDate();

                return dateA.compareTo(dateB);
              });

              return ListView(
                children: sortedList.map(
                        (element){
                      Timestamp timestamp = element['createdAt'] as Timestamp;
                      DateTime date = timestamp.toDate();
                      return _buildDiaryContainer(date,element['contents']);
                    }
                ).toList(),
              );
            }
        )
    );
  }
  Widget _buildDiaryContainer(DateTime date, String contents){
    int month = date.month;
    int day = date.day;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text: '$month월 $day일',style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    const TextSpan(text: '의 기록', style: TextStyle(fontSize: 16, color: Colors.grey,))
                  ]
              )
          ),

          const SizedBox(height: 2,),
          const Divider(thickness: 2,),
          const SizedBox(height: 8,),
          Text(contents)
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1,1),
                blurRadius: 3
            )
          ]
      ),
      padding: const EdgeInsets.all(15),
    );
  }
}
