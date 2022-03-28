import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController{

  String? _token;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  // 다큐먼트 스냅샷
  Stream<DocumentSnapshot> documentStream= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();



  @override
  void onInit() {
    super.onInit();
  }

}