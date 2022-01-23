import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database=FirebaseDatabase(databaseURL: 'https://bybloommvp-default-rtdb.asia-southeast1.firebasedatabase.app/');

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
  static Future<User?> register( String email, String password ,String nickname) async {
    User? user;


    try {
      UserCredential s= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await s.user!.updateDisplayName(nickname);
      database.ref("users/${s.user!.uid}").set({"usernickname":nickname});
      return s.user;
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

  static User? getcurrentUser( ) { //이게 제일 많이 씀..현 유저 들고오기
    FirebaseAuth auth = FirebaseAuth.instance;

    User? currentuser = auth.currentUser;

    return currentuser;
  }

  static logout(){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
  }

}