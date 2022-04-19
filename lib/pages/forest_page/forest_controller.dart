import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';


class ForestController extends GetxController {

  List<RxBool> checkbox=List.filled(100, RxBool(false));
  
  RxMap lastMessages = {}.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    lastMessages.bindStream(FirebaseFirestore.instance.collection('rooms')
        .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('updatedAt', descending: true).snapshots().map((col) {
          List<QueryDocumentSnapshot> docs = col.docs;
          List lastMessageList = docs.map((element){
            return element.get('lastMessage');
          }).toList();
          List docIdList = docs.map((element){
            return element.id;
          }).toList();
          Map finalMap = Map.fromIterables(docIdList, lastMessageList);
          return finalMap;
    }));
  }


}

