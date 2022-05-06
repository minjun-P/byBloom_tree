import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';



class MissionAComment extends GetView<MissionController> {
  const MissionAComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()=>
        Scaffold(
          appBar: AppBar(
            title: Obx(()=> Text('오늘의 말씀 day${controller.day.value}')),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: Get.width*0.6,
                    child: const Text('다른 사람들의 생각을 알 수 있어요. 공감되는 생각에 하트를 눌러주세요!'),
                  ),
                ),
                const Text('최신순'),
                const Divider(thickness: 2,color: Colors.grey,),
                StreamBuilder<QuerySnapshot>(
                  stream: controller.missionsRef.doc('day${controller.day.value}').collection('category').doc('A').collection('comments').orderBy('createdAt',descending: true).snapshots(),
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
                            Spacer(),
                            Center(child: Text(
                                '아직 댓글이 없습니다',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                            )),
                            Spacer()
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){

                          List<QueryDocumentSnapshot> snapshotList = snapshot.data!.docs;
                          QueryDocumentSnapshot specificSnapshot = snapshotList[index];
                          Map<String,dynamic> data = specificSnapshot.data() as Map<String,dynamic>;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  // 프로필 사진
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
                                      Text(data['contents']),
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                  const Spacer(),
                                  // 삭제 로직

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
                                                    controller.deleteComment(docId:snapshotList[index].id, type: 'A');
                                                    Get.back(closeOverlays: true);
                                                  },
                                                ),
                                              );
                                            }

                                        );

                                      },
                                    ),
                                  ),
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
                                                              type: 'A',
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
                                        controller.minusLikeCount(docId: snapshotList[index].id,type: 'A');
                                      } else {
                                        controller.plusLikeCount(docId: snapshotList[index].id, type: 'A');
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

                                ],
                              ),


                            ],
                          );
                        },
                        separatorBuilder: (_,__) => const Divider(thickness: 2,),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60,)
              ],
            ),
          ),
          /// 댓글 텍스트 창
          bottomSheet: !controller.missionCompleted['A']!
              ?Container(
            height: 80,
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
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                const SizedBox(width:10),
                Expanded(
                    child: TextFormField(
                      controller: controller.commentControllerA,
                      decoration: const InputDecoration(
                          hintText: '랄라블라로 의견 남기기'
                      ),
                      maxLines: 2,
                    )
                ),
                // 댓글 남기기
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: (){
                    // 텍스트가 있을 때만
                    if (controller.commentControllerA.text.isNotEmpty){
                      controller.uploadComment(comment: controller.commentControllerA.text,type: 'A');
                      controller.updateComplete(comment: controller.commentControllerA.text,type: 'A');
                      controller.clearMission();
                      controller.commentControllerA.clear();

                    }

                  },
                )
              ],
            ),
          ):null,
        ),
      ),
    );
  }
}
