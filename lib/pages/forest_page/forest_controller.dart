
import 'package:bybloom_tree/main_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class ForestController extends GetxController {

  List<RxBool> checkbox = List.filled(100, RxBool(false));

  RxMap lastMessages = {}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    lastMessages.bindStream(FirebaseFirestore.instance.collection('rooms')
        .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('updatedAt', descending: true).snapshots().map((col) {
      List<QueryDocumentSnapshot> docs = col.docs;
      List lastMessageList = docs.map((element) {
        return element.get('lastMessage');
      }).toList();
      List docIdList = docs.map((element) {
        return element.id;
      }).toList();
      Map finalMap = Map.fromIterables(docIdList, lastMessageList);
      return finalMap;
    }));
  }

  List colorFromString(types.Room room) {
    return room.imageUrl!.split(',')
        .map((element) => int.parse(element))
        .toList();
  }

  Future<List> getUserToken(String uid) async {
    var data = await FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .get();
    List tokenList = data.data()!['tokens']  ?? [] ;

    return tokenList;
  }

  sendFCMformessage(types.Room room, String name, String message) async {
    List roomtokenslist = [];
    for (int i =0; i < room.users.length; i++) {
      if (room.users[i].id != FirebaseAuth.instance.currentUser!.uid) {
        List tokens = await getUserToken(room.users[i].id) ;
        roomtokenslist += tokens;
      }
      roomtokenslist.forEach((element) {
        Get.find<MainController>().sendFcm(
            token: element, title: name, body: message);
      });
    }
  }
}

