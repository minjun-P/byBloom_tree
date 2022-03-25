import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


enum MissionType {qt, surveyA, surveyB }
/// 여기서 미션 day 랑 미션 메칭 컨트롤
class Mission {
  String title;
  String question;
  MissionType type;
  Map? contents;
  Mission({required this.title, required this.question, required this.type, this.contents});
}


List<Mission> missionList = [
  Mission(
    title: '오늘의 말씀',
    question: '무엇보다 열심으로 \n서로 사랑할찌니\n 사랑은 허다한 죄를 덮느니라',
    type: MissionType.qt,
    contents: {
      'from':'창세기 3:3'
    }
  ),
  Mission(
    title: '나눔미션',
    question: '가장 좋아하는\n찬양이 있으신가요?\n이유를 알려주세요.',
    type: MissionType.surveyA
  ),
  Mission(
    title: '교회연계미션',
    question: '우리 교회의 \n가장 큰 장점을\n알려주세요.',
    type: MissionType.surveyA
  ),
  Mission(
    title: '감사일기',
    question: '가장 좋아하는\n성경인물을\n골라주세요!',
    type: MissionType.surveyB,
    contents: {
      'choices':['모세','아브라함','사도바울','베드로']
    }
  )
];

/// 그냥 각 미션 별로 체크 박스만 만들어놓음.
/// db 연결하면서 미션 목록 불러오고, 완료 여부 확인도 할 수 있도록 해야할 듯.
class MissionController extends GetxController {
  // 미션 수행여부 컨트롤
  RxList<bool> missionComplete = [false,false,false,false,false,false].obs;
  void updateMissionComplete(int index) {
    missionComplete[index] = !missionComplete[index];
  }
  // 미션 내부 정보 컨트롤
  CollectionReference missions = FirebaseFirestore.instance.collection('missions');
  Rx<int> day = 1.obs;
  RxMap<String,dynamic> missionA = RxMap<String,dynamic>({});
  RxMap missionsB = {}.obs;
  RxMap missionC = {}.obs;

  late PanelController panelController;
  // functions 컨트롤
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  Future<void> updateToday() async {
    HttpsCallable callable = functions.httpsCallable('updateToday');
    final resp = await callable.call();
  }

  Future<void> getFruit() async {
    HttpsCallable callable = functions.httpsCallable('updateToday');
    final results = await callable();
    print(results.data);

    /**
    print('hiddddddddddddddddddddd');
    List fruit = results.data;  // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
    print(fruit);
  */
        }

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    panelController = PanelController();
    day.bindStream(missions.doc('today').snapshots().map((event) => event.get('day')));
    ever(day, (day) async {
      print('day: $day');
      DocumentSnapshot<Map<String,dynamic>> data = await missions.doc('day${day}').collection('category').doc('A').get();
      missionA.addAll(data.data()!);
    });
    //missionA.bindStream(missions.doc('day${day.value}').collection('category').doc('A').snapshots().map((event)=>event.data()!));
  }

  // 미션 내부 변수
  Rx<bool> opened = false.obs;
  Rx<int> bibleIndex = 0.obs;

}