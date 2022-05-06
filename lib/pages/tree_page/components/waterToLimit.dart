import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../mission_page/mission_controller.dart';

class WaterToLimit extends StatelessWidget {
  const WaterToLimit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // 줄 수 있는 물의 수
      StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('waterTo').doc('day${Get.find<MissionController>().day.value}').snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }
          // 기본 물 주기 횟수
          int basicNum = 3;
          if (!snapshot.data!.exists){
            return Column(
              children: [
                Text('오늘의 물 주기 횟수는 $basicNum번 남았습니다'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(basicNum, (index) => const Icon(MdiIcons.water,color: Colors.blue,)),
                ),
              ],
            );
          } else{
            List list = snapshot.data!.data()!['list'] as List;
            int len = list.length;
            int possible = basicNum - len;
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  const Text('오늘의 물 주기 횟수는',),
                  Text('$possible번 남았습니다'),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(possible, (index) => const Icon(MdiIcons.water,color: Colors.blue,)),
                  ),
                ],
              ),
            );
          }

        },
      );
  }
}
