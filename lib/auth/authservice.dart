import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
  static Future<User?> register( String phonenumber, String name, String Sex, String nickname,String birth,double slidevalue) async {
    User? user;


    try {
      user= await FirebaseAuth.instance.currentUser;
      print("users/${user?.uid}");
      database.ref("users/${user?.uid}").set({"username":name,"birthdate":birth,"Sex":Sex,"nickname":nickname,"phonenumber":phonenumber,"slidevalue":slidevalue})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      ;
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