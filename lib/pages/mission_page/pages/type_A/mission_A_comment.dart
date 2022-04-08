import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/main_screen.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';
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
                  child: Container(
                    width: Get.width*0.6,
                    child: Text('다른 사람들의 생각을 알 수 있어요. 공감되는 생각에 하트를 눌러주세요!'),
                  ),
                ),
                Text('최신순'),
                Divider(thickness: 2,color: Colors.grey,),
                StreamBuilder<QuerySnapshot>(
                  stream: controller.missionsRef.doc('day${controller.day.value}').collection('category').doc('A').collection('comments').orderBy('createdAt',descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return const Text('오류가 발생했어요!');
                    }

                    if (snapshot.connectionState ==ConnectionState.waiting){
                      return Expanded(
                        child: Column(
                          children: [
                            Spacer(),
                            Center(child: const CircularProgressIndicator()),
                            Spacer()
                          ],
                        ),
                      );
                    }
                    if (snapshot.data!.docs.length==0){
                      return Expanded(
                        child: Column(
                          children: [
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
                          Map<String,dynamic> data = snapshotList[index].data() as Map<String,dynamic>;
                          return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data['writer'], style: TextStyle(color: Colors.grey),),
                                          Text(data['contents']),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                      Spacer(),
                                      // 삭제 로직

                                      Visibility(
                                        visible: data['uid']==DbController.to.currentUserModel.value.uid,
                                        child: TextButton(
                                          child: Text('삭제'),
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  // 삭제 확인 알림
                                                  return AlertDialog(
                                                    title: Text('정말 삭제하시겠습니까?'),
                                                    content: OutlinedButton(
                                                      child: Text('네'),
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
                              )
                          );
                        },
                        separatorBuilder: (_,__) => const Divider(thickness: 2,),
                      ),
                    );
                  },
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
          /// 댓글 텍스트 창
          bottomSheet: !controller.missionCompleted['A']!
              ?Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                boxShadow: [
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
                CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                SizedBox(width:10),
                Expanded(
                    child: TextFormField(
                      controller: controller.commentControllerA,
                      decoration: InputDecoration(
                          hintText: '랄라블라로 의견 남기기'
                      ),
                      maxLines: 2,
                    )
                ),
                // 댓글 남기기
                IconButton(
                  icon: Icon(Icons.send),
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
