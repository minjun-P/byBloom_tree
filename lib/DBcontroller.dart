import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'auth/FriendModel.dart';
import 'auth/User.dart';

class DbController extends GetxController{

  static DbController get to => Get.find();

  String? _token;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  // 다큐먼트 스냅샷
  Stream<DocumentSnapshot> documentStream= FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  Rx<UserModel> currentUserModel = UserModel(
    uid: '',
    phoneNumber: '',
    name: '',
    birth: '',
    sex: '',
    level: 1,
    exp: 0,
    createdAt: DateTime.now(),
    imageUrl: '',
    slideValue: 0,
    nickname: '',
    friendList: [],
    friendPhoneList: [],
    lastName: '',
    firstName: ''
  ).obs;


  @override
  void onInit() async{
    super.onInit();
    currentUserModel.bindStream(FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots().map((event) {
      Map<String,dynamic> data = event.data()!;
      String uid = event.id;
      // 친구 폰 목록
      List<String> friendPhoneList = List<String>.from(data['friendPhoneList'] );
      return UserModel(
          uid:uid,
          phoneNumber:data['phoneNumber'],
          name:data['name'],
          birth: data['birth'],
          sex: data['Sex'],
          level: data['level'],
          exp:data['exp'],
          createdAt: data['createdAt'].toDate(),
          imageUrl: data['imageUrl'],
          slideValue: data['slideValue'],
          nickname: data['nickname'],
          friendList: [] ,
          friendPhoneList: friendPhoneList,
          lastName: data['name'],
          firstName: ""
      );
    }));
    ever(currentUserModel,(_){
      _ as UserModel;
      uploadFriend(currentUserModel.value);
    });

    print("유저업데이트완료");
  }



  // 유저 만드는 메소드
  Future<Rx<UserModel>> makeUserModel( ) async {
    String uid= FirebaseAuth.instance.currentUser!.uid;


    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // 현재 내 계정 디비 가져오기
    DocumentSnapshot doc = await users.doc(uid).get();
    Map<String,dynamic> data= doc.data() as Map<String,dynamic>;

    // 친구 폰 목록
    List<String> friendPhoneList = List<String>.from(data['friendPhoneList'] );


    UserModel userModel = UserModel(
        uid:uid,
        phoneNumber:data['phoneNumber'],
        name:data['name'],
        birth: data['birth'],
        sex: data['Sex'],
        level: data['level'],
        exp:data['exp'],
        createdAt: data['createdAt'].toDate(),
        imageUrl: data['imageUrl'],
        slideValue: data['slideValue'],
        nickname: data['nickname'],
        friendList: [] ,
        friendPhoneList: friendPhoneList,
        lastName: data['name'],
        firstName: ""
    );
    print("유저모델생성완료");

    return userModel.obs;

  }

  // 친구 만드는 메소드
  bool uploadFriend(UserModel currentUser){
    try {
      // 이미 만들어진 friendPhoneList 불러오고
      List<String> friendPhoneList = currentUser.friendPhoneList;
      // friendPhoneList 로 for 문
      friendPhoneList.forEach((phone) async {

        FriendModel? myFriend= await findUserFromPhone(phone);
        currentUser.friendList.add(myFriend!);
      });

      return true;
    }catch(error){
      print(error);
      return false;
    }
  }
  // 디비에서 phoneNum 가져와서 하나하나 쿼리 => FriendModel 리턴
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
}