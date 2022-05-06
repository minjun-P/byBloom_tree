import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../mission_controller.dart';

class NoSelectionAnswer extends GetView<MissionController> {
  final bool prior;
  final int day;
  final Map missionData;
  const NoSelectionAnswer({
    Key? key,
    required this.missionData,
    required this.day,
    required this.prior

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()=>
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: null,
              toolbarHeight: 50,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: Get.width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2
                        )
                      ],
                      color: Colors.white
                  ),
                  child: SizedBox(
                    width: 230,
                    child: Text(
                      missionData['제목'],
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: controller.missionsRef.doc('day$day').collection('category').doc('B').collection('comments').orderBy('createdAt',descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return const Text('오류가 발생했어요!');
                    }

                    if (snapshot.connectionState ==ConnectionState.waiting){
                      return Expanded(
                        child: Column(
                          children: const [
                            Spacer(),
                            Center(child: CircularProgressIndicator()),
                            Spacer()
                          ],
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty){
                      return Expanded(
                        child: Column(
                          children: const [
                            Spacer(flex: 1,),
                            Center(child: Text(
                              '아직 댓글이 없습니다',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),

                            )),
                            Spacer(flex: 2,)
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            const Divider(thickness: 2,),
                            const SizedBox(height: 10,),
                            Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index){

                                  List<QueryDocumentSnapshot> snapshotList = snapshot.data!.docs;
                                  QueryDocumentSnapshot specificSnapshot = snapshotList[index];
                                  Map<String,dynamic> data = specificSnapshot.data() as Map<String,dynamic>;
                                  return Row(
                                    children: [
                                      FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                      future: FirebaseFirestore.instance.collection('users').doc(data['uid']).get(),
                                      builder: (context,snapshot) {
                                        if (snapshot.hasError) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey.shade200,
                                          );
                                        }
                                        if (snapshot.connectionState==ConnectionState.waiting){
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey.shade200,
                                          );
                                        }
                                        // uid data 가 존재하지 않을 때, 즉 회원 탈퇴를 했을 때 처리 -> 토끼로 고정
                                        if (!snapshot.data!.exists){
                                          return const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/profile/a_1.png',
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        }
                                        String profileImage = snapshot.data!.data()!['profileImage'];
                                        return CircleAvatar(
                                          backgroundImage: AssetImage(
                                            'assets/profile/$profileImage.png',
                                          ),
                                          backgroundColor: Colors.white,
                                        );
                                      }
                                  ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data['writer'], style: const TextStyle(color: Colors.grey),),
                                          const SizedBox(height: 10,),
                                          Text(data['contents'], style: const TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      const Spacer(),
                                      Visibility(
                                        visible: data['uid']==DbController.to.currentUserModel.value.uid,
                                        child: TextButton(
                                          child: const Text('삭제'),
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  // 삭제 확인 알림
                                                  return AlertDialog(
                                                    title: const Text('정말 삭제하시겠습니까?'),
                                                    content: OutlinedButton(
                                                      child: const Text('네'),
                                                      onPressed: (){
                                                        controller.deleteComment(docId:snapshotList[index].id, type: 'B');
                                                        Get.back(closeOverlays: true);
                                                      },
                                                    ),
                                                  );
                                                }

                                            );

                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          MdiIcons.heartOutline,
                                          color: List.castFrom(data['like']).contains(DbController.to.currentUserModel.value.uid)
                                              ?Colors.red
                                              :Colors.black,
                                          size: 20,
                                        ),
                                        onPressed: ()async{
                                          if (List.castFrom(data['like']).contains(DbController.to.currentUserModel.value.uid)){
                                            controller.minusLikeCount(docId: snapshotList[index].id,type: 'B');
                                          } else {
                                            controller.plusLikeCount(docId: snapshotList[index].id, type: 'B');
                                            var user = await FirebaseFirestore.instance.collection('users').doc(data['uid']).get();
                                            Map<String,dynamic> map = user.data()!;
                                            List tokens = map['tokens'] as List;
                                            tokens.forEach((element){
                                              Get.find<MainController>().sendFcm(
                                                  token: element,
                                                  title: '띵동',
                                                  body: '${DbController.to.currentUserModel.value.name}님이 댓글에 좋아요를 눌렀어요!'
                                              );
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                          List.castFrom(data['like']).length.toString()
                                      ),
                                      // 삭제

                                      // 신고
                                      Visibility(
                                        visible: data['uid']!=DbController.to.currentUserModel.value.uid,
                                        child: TextButton(
                                          child: const Text('신고'),
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  // 삭제 확인 알림
                                                  return AlertDialog(
                                                    title: const Text('정말 신고하시겠습니까?'),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text('<신고 사유>'),
                                                        TextFormField(
                                                          controller: controller.reportControllerA,
                                                          maxLines: 3,
                                                          decoration: const InputDecoration(
                                                              hintText: '사유를 입력해야 제출이 가능합니다.'
                                                          ),
                                                        ),
                                                        OutlinedButton(
                                                          child: const Text('제출'),
                                                          onPressed: (){
                                                            if (controller.reportControllerA.text.isNotEmpty){
                                                              controller.reportComment(
                                                                  day: controller.day.value,
                                                                  type: 'B',
                                                                  reason: controller.reportControllerA.text,
                                                                  who: data['uid'],
                                                                  commentId: specificSnapshot.id

                                                              );

                                                              controller.reportControllerA.clear();
                                                              Get.back(closeOverlays: true);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                            );

                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                                separatorBuilder: (_,__) => const Divider(thickness: 2,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),
            /// 댓글 텍스트 창
            bottomSheet: controller.missionCompleted['B']!|prior
                ?null:Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0,-0.7),
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 0.1
                    )
                  ]
              ),
              child: Column(
                children: [

                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                        ),
                        const SizedBox(width:10),
                        Expanded(
                            child: TextFormField(
                              controller: controller.commentControllerB,
                              decoration: const InputDecoration(
                                  hintText: '의견 남기기'
                              ),
                              maxLines: 2,
                            )
                        ),
                        // 댓글 남기기
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: (){
                            // 텍스트가 있을 때만
                            if (controller.commentControllerB.text.isNotEmpty){
                              controller.uploadComment(comment: controller.commentControllerB.text,type: 'B',check: controller.checkbox.value);
                              controller.updateComplete(comment: controller.commentControllerB.text,type: 'B');
                              controller.clearMission();
                              controller.commentControllerB.clear();

                            }

                          },
                        )
                      ],
                    ),

                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Obx(()=>
                            Checkbox(
                              value: controller.checkbox.value,
                              onChanged: (bool? check){
                                controller.checkbox(check);
                              },
                            ),
                        ),
                        const Text('익명으로 남기기!')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}