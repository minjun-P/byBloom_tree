import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  final uid;
  final String name;
  final String phoneNumber;
  final DateTime createdAt;
  String nickname;
  String imageUrl;
  int level;
  int exp;
  String Sex;
  double slidevalue;
  String birth;
  List<String> friendphonelist;
  List<FriendModel> friendlist;



  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.createdAt,
    required this.exp,
    required this.imageUrl,
    required this.level,
    required this.Sex,
    required this.birth,
    required this.slidevalue,
    required this.friendlist,
    required this.friendphonelist

});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'createdAt': createdAt,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl,
    'Sex':Sex,
    'birth':birth,
    'slidevalue':slidevalue,
    'frinedphoneList':friendphonelist


  };

  bool AddFriend( FriendModel s){
    friendphonelist.add(s.phoneNumber);
    friendlist.add(s);
    FirebaseFirestore.instance.collection('users')
        .doc(uid).update({'friendphonelist':friendphonelist});
    return true;
  }
}


Future<String?> findusernamefromphone(String phonenum) async {
  var friend =  await FirebaseFirestore.instance.collection('users').
  where('phonenumber',isEqualTo:phonenum).
  snapshots().first;

  if (friend != null) {
    return friend.docs[0].data()['nickname'];


}

  return null;
}

Future<FriendModel?> finduserfromphone(String phonenum) async {
  var friend =  await FirebaseFirestore.instance.collection('users').
  where('phonenumber',isEqualTo:phonenum).
  snapshots().first;

  if (friend != null) {
    return new FriendModel(
        name: friend.docs[0].data()['name'],
        phoneNumber:friend.docs[0].data()['phoneNumber'],
        nickname: friend.docs[0].data()['nickname'],
        exp: friend.docs[0].data()['exp'],
        imageUrl: friend.docs[0].data()['imageUrl'],
        level: friend.docs[0].data()['level']);
  }

  return null;
}


