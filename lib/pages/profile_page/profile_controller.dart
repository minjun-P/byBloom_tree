import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProfileController extends GetxController with GetTickerProviderStateMixin{
  var fireStore= FirebaseFirestore.instance;

  @override
  void onInit() async {

    super.onInit();
    dayCount.bindStream(missionCompletedRef.snapshots().map((collection){
      List<QueryDocumentSnapshot> list =collection.docs;
      List filteredList = list.where((element) {
        Map temp = element.data() as Map;
        return temp.isNotEmpty;
      }).toList();
      return filteredList.length;
    }));
    missionCount.bindStream(missionCompletedRef.snapshots().map((collection) {
      List<QueryDocumentSnapshot> list =collection.docs;
      List<QueryDocumentSnapshot> filteredList = list.where((element) {
        Map temp = element.data() as Map;
        return temp.isNotEmpty;
      }).toList();
      int sum = 0;
      for (var document in filteredList) {
        Map map = document.data() as Map;
        sum +=map.length;
      }
      return sum;
    }));

  }
  Rx<int> missionCount= 0.obs;
  Rx<int> dayCount = 0.obs;
  var missionCompletedRef = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).collection('mission_completed');

  Stream<List> getDiaryStream(){
    Stream<QuerySnapshot<Map<String,dynamic>>> snapshot = missionCompletedRef.snapshots();
    Stream<List> diaryStream = snapshot.map((event){
      // document snapshot 으로 이루어진 리스트
      List<QueryDocumentSnapshot> list = event.docs;
      // 미션 C, 일기가 작성된 day document 로 필터링
      List<QueryDocumentSnapshot> filteredList = list.where((element) {
        Map temp = element.data() as Map;
        return temp['C']!=null;
      }).toList();
      // 미션 C 의 데이터가 순서대로 들어있는
      List diaryList = filteredList.map((document){
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;
        return map['C'];
      }).toList();
      return diaryList;
    });
    return diaryStream;
  }
  Stream<List> getWorshipStream() {
    Stream<QuerySnapshot<Map<String,dynamic>>> snapshot = missionCompletedRef.snapshots();
    Stream<List> worshipStream = snapshot.map((event){
      // document snapshot 으로 이루어진 리스트
      List<QueryDocumentSnapshot> list = event.docs;
      // 미션 D가 작성이 된 day Docs 만 필터링!
      List<QueryDocumentSnapshot> filteredList = list.where((element) {
        Map temp = element.data() as Map;
        return temp['D']!=null;
      }).toList();
      // 미션 D 의 데이터가 순서대로 들어있는
      List worshipList = filteredList.map((document){
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;
        return map['D'];
      }).toList();
      return worshipList;
    });
    return worshipStream;
  }


  Map profileComment ={
    1:'통통한 씨앗',
    2:'귀여운 새싹',
    3:'아기 나무',
    4:'어린 나무',
    5:'청년 나무',
    6:'꽃 핀 나무',
    7:'열매 맺은 나무'
  };

}