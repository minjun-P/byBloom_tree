import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProfileController extends GetxController with GetTickerProviderStateMixin{
  var fireStore= FirebaseFirestore.instance;

  @override
  void onInit() async {

    RxString downloadURL;
    RxString Username;
    RxString Usernickname;
    super.onInit();
    Stream<Map> profileDetail() {
      Stream<DocumentSnapshot> documentStream = fireStore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
      return documentStream.map((event) => {'exp':event.get('exp'),'level':event.get('level')});
    }
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
      filteredList.forEach((document){
        Map map = document.data() as Map;
        sum +=map.length;
      });
      return sum;
    }));

  }
  Rx<int> missionCount= 0.obs;
  Rx<int> dayCount = 0.obs;
  var missionCompletedRef = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).collection('mission_completed');


}