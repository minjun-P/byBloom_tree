import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../main_controller.dart';
import '../../../tree_page/tree_controller.dart';
import '../mission_types/type_survey_a.dart';

class MissionBPage extends GetView<MissionController> {
  const MissionBPage({Key? key}) : super(key: key);

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
                padding: EdgeInsets.all(20),
                height: 150,
                decoration: BoxDecoration(
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
                    controller.missionB['제목'],
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: controller.missionsRef.doc('day${controller.day.value}').collection('category').doc('B').collection('comments').orderBy('createdAt',descending: true).snapshots(),
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

                  if (controller.missionB['객관식']){
                    /// 객관식일 때
                    String str = controller.missionB['추가'] as String;
                    List list = str.split(',');
                    List index = [1,2,3,4];

                    return Obx(()=>
                      Column(
                        children: [
                          ...index.map((element)=>
                            GestureDetector(
                              onTap: (){
                                controller.selectedContainer(element);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 7),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey,blurRadius: 2,spreadRadius: 0,offset: Offset(1,1))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: controller.selectedContainer.value==element?Colors.greenAccent:Colors.white

                                ),
                                  width: Get.width*0.8,
                                  height: 70,
                                  child: Text(
                                      'A.'+element.toString()+' '+list[element-1],
                                    style: TextStyle(
                                      fontSize: 20,

                                    ),

                                  )
                              ),
                            )
                        ).toList(),
                          SizedBox(height: 20,),
                          ElevatedButton(
                              child: Text('제출하기',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              onPressed: (){
                                if (controller.selectedContainer.value!=0){
                                  controller.uploadComment(
                                      comment: controller.selectedContainer.value.toString(), type: 'B'
                                  );
                                  controller.updateComplete(
                                      comment: controller.selectedContainer.value.toString(),type: 'B'
                                  );
                                }


                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffA0C6FF),
                                  fixedSize: Size(Get.width*0.7,50)
                              )
                          ),


                        ]
                      ),
                    );

                  } else {
                    /// 주관식(댓글 형태)일 때 
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
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['writer'], style: TextStyle(color: Colors.grey),),
                                      SizedBox(height: 10,),
                                      Text(data['contents'], style: TextStyle(color: Colors.black),)
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      MdiIcons.heartOutline,
                                      color: List.castFrom(data['like']).contains(Get.find<TreeController>().currentUserModel!.uid)
                                          ?Colors.red
                                          :Colors.black,
                                      size: 20,
                                    ),
                                    onPressed: ()async{
                                      if (List.castFrom(data['like']).contains(Get.find<TreeController>().currentUserModel!.uid)){
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
                                              body: '${Get.find<TreeController>().currentUserModel!.name}님이 댓글에 좋아요를 눌렀어요!'
                                          );
                                        });

                                      }

                                    },
                                  ),
                                  Text(
                                      List.castFrom(data['like']).length.toString()
                                  ),
                                  Visibility(
                                    visible: data['uid']==Get.find<TreeController>().currentUserModel!.uid,
                                    child: TextButton(
                                      child: Text('삭제'),
                                      onPressed: (){
                                        controller.deleteComment(docId:snapshotList[index].id, type: 'B');
                                      },
                                    ),
                                  )
                                ],
                              )
                          );
                        },
                        separatorBuilder: (_,__) => const Divider(thickness: 2,),
                      ),
                    );
                  }
                },
              ),

            ],
          ),
          /// 댓글 텍스트 창
          bottomSheet: (!controller.missionCompleted['B']!)&&!controller.missionB['객관식']!
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
                      controller: controller.commentControllerB,
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
                    if (controller.commentControllerB.text.isNotEmpty){
                      controller.uploadComment(comment: controller.commentControllerB.text,type: 'B');
                      controller.updateComplete(comment: controller.commentControllerB.text,type: 'B');
                      controller.commentControllerB.clear();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('수고하셨어요!'),
                              content: Text('느낀점을 남겨 경험치가 30 증가했어요!'),
                            );
                          }
                      );
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
