import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  final String uid;
  final String name;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime createdAt;
  String nickname;
  String imageUrl;
  int level;
  int exp;
  String sex;
  double slideValue;
  String birth;
  List<String> friendPhoneList;
  List<FriendModel> friendList;

/// 내가사용하는 채팅패키지를 이용하려면 firstName이랑 lastName이라는 변수가있는게 압도적으로 좋은거같아서..어
  /// 내부 패키지 뜯어서 고쳐보다가 포기하고 걍 두 변수 만들었


  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.createdAt,
    required this.exp,
    required this.imageUrl,
    required this.level,
    required this.sex,
    required this.birth,
    required this.slideValue,
    required this.friendList,
    required this.friendPhoneList,
    required this.firstName,
    required this.lastName

});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'createdAt': createdAt,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl,
    'Sex':sex,
    'birth':birth,
    'slideValue':slideValue,
    'friendPhoneList':friendPhoneList,
    'firstName':firstName,
    'lastName':lastName



  };

  bool addFriend( FriendModel s){
    friendPhoneList.add(s.phoneNumber);
    friendList.add(s);
    FirebaseFirestore.instance.collection('users')
        .doc(uid).update({'friendPhoneList':friendPhoneList});
    return true;
  }
}


Future<String?> findUserNameFromPhone(String phoneNum) async {
  var friend =  await FirebaseFirestore.instance.collection('users').
  where('phoneNumber',isEqualTo:phoneNum).
  snapshots().first;

  if (friend != null) {
    return friend.docs[0].data()['nickname'];


}

  return null;
}
Future<String?> finduidFromPhone(String phoneNum) async {
  var friend =  await FirebaseFirestore.instance.collection('users').
  where('phoneNumber',isEqualTo:phoneNum).
  snapshots().first;

  if (friend != null) {
    return friend.docs[0].id;


  }

  return null;
}

Future<FriendModel?> findUserFromPhone(String phoneNum) async {
  var friend =  await FirebaseFirestore.instance.collection('users').
  where('phoneNumber',isEqualTo:phoneNum).get()
  ;

  if (friend.size!=0) {
    print(friend.docs[0].data()['name']);
    return FriendModel(
        name: friend.docs[0].data()['name'],
        phoneNumber:friend.docs[0].data()['phoneNumber'],
        nickname: friend.docs[0].data()['nickname'],
        exp: friend.docs[0].data()['exp'],
        imageUrl: friend.docs[0].data()['imageUrl'],
        level: friend.docs[0].data()['level'],
        tokens: friend.docs[0].data()['tokens'],
        uid:  friend.docs[0].id
    );
  }


  return null;
}


