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
    name: '로딩중',
    birth: '',
    sex: '',
    level: 1,
    exp: 0,
    createdAt: DateTime.now(),
    profileImage: '',
    church: '',
    slideValue: 0,
    nickname: '',
    friendList: [],
    friendPhoneList: [],
    lastName: '',
    firstName: '',
    imageUrl: ''
  ).obs;

  Rx<int> day = 1.obs;
  Rx<int> waterToLimit = 0.obs;

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
          slideValue: data['slideValue'],
          nickname: data['nickname'],
          friendList: [] ,
          friendPhoneList: friendPhoneList,
          lastName: data['name'],
          firstName: "",
          profileImage: data['profileImage']??'',
          church: data['church']??'',
          imageUrl: data['profileImage']
      );
    }));
    day.bindStream(FirebaseFirestore.instance.collection('missions').doc('today').snapshots().map((element) => element.get('day')));

    // day 바뀔 때마다 호출
    ever(day,(day){
      waterToLimit.bindStream(FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('waterTo').doc('day$day').snapshots().map((document) {
        int basicNum = 3;
        // document 존재하지 않을 때
        if (!document.exists) {
          return basicNum;
        } else {
          List list = document.data()!['list'] as List;
          int len = list.length;
          int possible = basicNum - len;
          return possible;
        }
      }));
    });

    // currentUserModel이 바뀔 때마다, 호출
    ever(currentUserModel,(_){
      _ as UserModel;
      print('currentUserModel 업데이트');
      uploadFriend(currentUserModel.value);
    });

    print("유저업데이트완료");
  }

  // 친구 만드는 메소드
  void uploadFriend(UserModel currentUser){
    try {
      // 이미 만들어진 friendPhoneList 불러오고
      List<String> friendPhoneList = currentUser.friendPhoneList;
      // friendPhoneList 로 for 문
      friendPhoneList.forEach((phoneNum) async {

        FriendModel? myFriend= await findUserFromDb(phoneNum);
        if(myFriend!=null){
          currentUser.friendList.add(myFriend);}
      });

    }catch(error){
      print(error);
    }
  }
  // 디비에서 phoneNum 가져와서 하나하나 쿼리 => FriendModel 리턴
  Future<FriendModel?> findUserFromDb(String phoneNum) async {
    // users 컬렉션에서 검색하기
    var friend =  await FirebaseFirestore.instance.collection('users').
    where('phoneNumber',isEqualTo:phoneNum).get();
    // 검색 결과가 있으면
    if (friend.size!=0) {
      print(friend.docs[0].data()['name']);
      return FriendModel(
          name: friend.docs[0].data()['name'],
          phoneNumber:friend.docs[0].data()['phoneNumber'],
          nickname: friend.docs[0].data()['nickname'],
          exp: friend.docs[0].data()['exp'],
          profileImage: friend.docs[0].data()['profileImage'],
          level: friend.docs[0].data()['level'],
          tokens: friend.docs[0].data()['tokens'],
          uid:  friend.docs[0].id
      );
    } else {
      // 검색 결과가 없으면, 해당하는 번호를 가진 user 가 없다면
      return null;
    }
  }
}