

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

deleteroomfromuser() {
  final doc= FirebaseFirestore.instance.collection('rooms')
      .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('updatedAt', descending: true).snapshots();
  doc.forEach((element) {
    element.docs.forEach((element) {
      var id=element.id;
      FirebaseFirestore.instance.collection("rooms").doc(id).update({

        "userIds":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]) });
    });
  });
}

