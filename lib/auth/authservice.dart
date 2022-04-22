import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

FirebaseDatabase database=FirebaseDatabase.instance;
class authservice {// 로그인관련 서비스총괄하는 클래스
  //유저로그
  static Future<User?> signin( String email, String password ) async {
    User? user;
    try {
      UserCredential s= await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return s.user;
    }catch(e){
      print(e);
      return null;
    }
  }
  //유저등록
  static Future<User?> register({
    required String phoneNumber,
    required String name,
    required String sex,
    required String nickname,
    required String birth,
    required double slideValue,
    required String church,
    required String profileImage

  }) async {
    User? user;


    try {
      String uid= FirebaseAuth.instance.currentUser!.uid;
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      // UserModel 객체 형태로 임시 생성
      UserModel s= UserModel(
        phoneNumber:phoneNumber,
        name:name,
        birth: birth,
        sex: sex,
        level: 1,
        exp: 0,
        createdAt: DateTime.now(),
        slideValue: slideValue,
        nickname: nickname,
        uid:uid,
        friendList: [],
        friendPhoneList: [],
        lastName: name,
        firstName: "",
        church: church,
        profileImage: profileImage
      );
      // 디비에 등록 using toJson 메서드
      users.doc(uid).set(s.toJson())
          .then((value) => print("${s.toJson()} 등록 완료"))
          .catchError((error) => print("Failed to add user: $error"));

      return user;
    }catch(e){
      print(e);
      return null;
    }

  }
  static Future<User?> refreshUser(User user) async {//사실 이건 잘 모르겠는데쓰는게 좋다고 해서 일단 만듷어놓음
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static User? getCurrentUser( ) { //이게 제일 많이 씀..현 유저 들고오기
    FirebaseAuth auth = FirebaseAuth.instance;

    User? currentUser = auth.currentUser;

    return currentUser;
  }

  static logout(){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
  }

}