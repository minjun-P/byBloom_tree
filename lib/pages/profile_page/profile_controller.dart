import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProfileController extends GetxController with GetTickerProviderStateMixin{
  var fireStore= FirebaseFirestore.instance;

  void onInit() async {

    RxString downloadURL;
    RxString Username;
    RxString Usernickname;

    Stream<Map> profileDetail() {
      Stream<DocumentSnapshot> documentStream = fireStore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
      return documentStream.map((event) => {'exp':event.get('exp'),'level':event.get('level')});
    }


  }


}