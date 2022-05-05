import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mission_controller.dart';

class SelectionAnswer extends GetView<MissionController> {
  final bool prior;
  final Map missionData;
  final int day;
  const SelectionAnswer({
    Key? key,
    required this.prior,
    required this.missionData,
    required this.day

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  height: 120,
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
                      missionData['제목'],
                      style: TextStyle(fontSize: 22),
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
                          children: [
                            Spacer(),
                            Center(child: const CircularProgressIndicator()),
                            Spacer()
                          ],
                        ),
                      );
                    }
                    String str = missionData['추가'] as String;
                    List list = str.split(',');
                    List index = [1,2,3,4];

                    return Obx(() {
                      return Column(
                          children: [
                            ...index.map((element) =>
                                GestureDetector(
                                  onTap: controller.missionCompleted['B']!|prior
                                      ? null
                                      : () {
                                    controller.selectedContainer(element);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 7),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(color: Colors.grey,
                                                    blurRadius: 2,
                                                    spreadRadius: 0,
                                                    offset: Offset(1, 1))
                                              ],
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                              color: controller
                                                  .selectedContainer.value ==
                                                  element
                                                  ? Colors.greenAccent
                                                  : Colors.white

                                          ),
                                          width: Get.width * 0.8,
                                          height: 70,
                                          child: Text(
                                            'A.' + element.toString() + ' ' +
                                                list[element - 1],
                                            style: TextStyle(
                                              fontSize: 20,

                                            ),

                                          )
                                      ),
                                      //
                                      Positioned.fill(
                                        child: Visibility(
                                          visible: controller.missionCompleted['B']!|prior,
                                          child: FutureBuilder<double>(
                                              future: controller.getResultNum(
                                                  element,day),
                                              builder: (context, snapshot) {
                                                return Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: FractionallySizedBox(
                                                    widthFactor: snapshot
                                                        .connectionState ==
                                                        ConnectionState.done
                                                        ? snapshot.data
                                                        : 0,
                                                    heightFactor: 1,
                                                    child: Container(
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          vertical: 7),
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(

                                                          borderRadius: BorderRadius
                                                              .circular(20),
                                                          color: Colors.red
                                                              .withOpacity(0.2)

                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        right: 40,
                                        child: Visibility(
                                          visible: controller.missionCompleted['B']!|prior,
                                          child: FutureBuilder<double>(
                                              future: controller.getResultNum(
                                                  element,day),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState !=
                                                    ConnectionState.done) {
                                                  return const CircularProgressIndicator();
                                                }
                                                return Text(
                                                  (snapshot.data! * 100)
                                                      .toStringAsFixed(0) + '%',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                      color: Colors.blueGrey
                                                  ),
                                                );
                                              }
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ).toList(),
                            SizedBox(height: 5,),
                            Visibility(
                              visible: controller.missionCompleted['B']!|prior,
                              child: FutureBuilder<double>(
                                  future: controller.getResultNum(0,day),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Container();
                                    }
                                    return Text('답변 제출 수 : ' +
                                        snapshot.data!.toInt().toString());
                                  }
                              ),
                            ),
                            SizedBox(height: 10,),
                            ElevatedButton(
                                child: controller.missionCompleted['B']!|prior
                                    ? Text('제출 완료', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),)
                                    : Text('제출하기', style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                                onPressed: controller.missionCompleted['B']!|prior
                                    ? null
                                    : () {
                                  if (controller.selectedContainer.value != 0) {
                                    controller.uploadComment(
                                        comment: list[controller
                                            .selectedContainer.value - 1],
                                        type: 'B',
                                        index: controller.selectedContainer
                                            .value
                                    );
                                    controller.updateComplete(
                                        comment: list[controller
                                            .selectedContainer.value - 1],
                                        type: 'B'
                                    );
                                    controller.selectedContainer(0);
                                    controller.clearMission();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xffA0C6FF),
                                    fixedSize: Size(Get.width * 0.7, 50)
                                )
                            ),
                          ]
                      );

                    }
                    );
                  },
                ),

              ],
            ),
          ),
    );
  }
}
