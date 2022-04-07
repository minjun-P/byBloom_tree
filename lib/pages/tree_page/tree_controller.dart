import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/User.dart';

/// Tree 페이지의 컨트롤러
/// - 경험치 제어
/// - 나무 성장단계 제어
/// - 물받기 제어
/// 이러한 기능이 필요할 듯 하다.





class TreeController extends GetxController with GetTickerProviderStateMixin{


  Rx<bool> rain = false.obs;


  // 임시로 만든거, 푸시알림 보내기 기능
  late GlobalKey<FormState> formKey;



  RxInt exp = 0.obs;
  RxInt level = 0.obs;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<Map> userDetail() {
    Stream<DocumentSnapshot> documentStream = fireStore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    return documentStream.map((event) => {'exp':event.get('exp'),'level':event.get('level')});
  }

  /// 유저모델 관리
  UserModel? currentUserModel=null;

  Future<UserModel?> makeUserModel( ) async {

    User? user;
    try {
      user= await FirebaseAuth.instance.currentUser;
      print("users/${user?.uid}");
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      var doc=await users.doc(user?.uid).get();
      print('다큐먼트가져오기');
      var q=doc.data() as Map<String,dynamic>;
      print(q['phoneNumber']);
      print(q['friendPhoneList']);
      var array = q['friendPhoneList']; // array is now List<dynamic>
      List<String> strings = List<String>.from(array);

      UserModel s= UserModel(
          uid:user!.uid,
          phoneNumber:q['phoneNumber'],name:q['name'],
          birth: q['birth'], sex: q['Sex'], level: q['level'], exp:q['exp'],
          createdAt: q['createdAt'].toDate()
          , imageUrl: q['imageUrl'], slideValue: q['slideValue'], nickname: q['nickname'],
          friendList: [] ,
          friendPhoneList: strings,
          lastName: q['name'],
          firstName: "");
      print("유저모델생성완료");

      return s;
    }catch(e){
      print(e);
      print("에러발");
    }

  }

  bool uploadFriend(UserModel currentUser){
    try {
      List s = currentUser.friendPhoneList;
      s.forEach((index) async {
        print(index);
        FriendModel? myFriend ;
        myFriend=await findUserFromPhone(index) ;
        currentUser.friendList.add(myFriend!);
      });

      return true;
    }catch(error){
      print(error);
      return false;
    }
  }

  late AnimationController wateringIconController;
  late AnimationController rainController;
  late Animation<double> rainAnimation;

  late AnimationController levelUpAnimationController;
  late Animation<double> levelUpAnimation;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    /// 레벨업 애니메이션
    levelUpAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 5000)
    );
    levelUpAnimation = Tween<double>(
        begin: 0,
        end: 1
    ).animate(levelUpAnimationController);

    /// User 모델 초기화
    currentUserModel=await makeUserModel();
    print("UID:${currentUserModel?.name}");
    print(uploadFriend(currentUserModel!));

    /// 필요한 데이터 가져오기
    exp.bindStream(userDetail().map((event)=>event['exp']));
    level.bindStream(userDetail().map((event)=>event['level']));


    /// 물주기 애니메이션 - 임시
    wateringIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 0.05
    );
    rainController = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    rainAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(rainController);


    formKey = GlobalKey();




  }


  void animateWateringIcon() async {
    await wateringIconController.forward();
    await wateringIconController.reverse();
    await rainController.forward();
    await rainController.reverse();
  }

  void levelUp(){
    DocumentReference doc =FirebaseFirestore.instance.collection('users').doc(currentUserModel!.uid);
    doc.update({
      'exp':FieldValue.increment(-100),
      'level':FieldValue.increment(1)
    });
  }
  void templevelUp(){
    DocumentReference doc =FirebaseFirestore.instance.collection('users').doc(currentUserModel!.uid);
    doc.update({
      'level':FieldValue.increment(1)
    });
  }

  /// 알림보내기
  var title = ''.obs;
  var body = ''.obs;

  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  Future<void> sendFcm({required String token, required String title, required String body}) async {
    HttpsCallable callable = functions.httpsCallable('sendFCM');
    final resp = await callable.call(<String, dynamic> {
      'token': token,
      'title': title,
      'body': body
    });
    print(resp.data);
  }

  void show() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('메시지 보내기'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'title'
                  ),
                  initialValue: '',
                  onSaved: (text) {
                    title(text);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'body'
                  ),
                  initialValue: '',

                    onSaved: (text) {
                      body(text);
                    }
                ),
                ElevatedButton(
                  child: Text('에뮬레이터 보내기'),
                  onPressed: (){
                    formKey.currentState!.save();
                    sendFcm(
                      token: 'fjYFENbtSXSvgPyc7bBl5p:APA91bHkyMmxFR3u56XLU7ypMA7Te4knctP3Pgb1vfI-mr8A7az5ptolz0RRrASxWlzssAbUhUVrWYDxX1cMe0WDYOfd3EgMjwEkwxqd3pqIFXvo5q3izhH5fRtr4qowgFL5B1bG7kXx',
                      title: title.value,
                      body: body.value
                    );
                    formKey.currentState!.reset();
                  },
                ),
                ElevatedButton(
                  child: Text('폰으로 보내기'),
                  onPressed: (){
                    formKey.currentState!.save();
                    sendFcm(
                        token: 'eSKXF4mtTiide6s7IVnrUF:APA91bGSBvnupeRinLKxlgaAqu6hr4C8parXrCAy0lRtHP_w2Zbv8sjsKr5PGND659XldAahSTvPPMse8BEyZo7Is87a3p5raFE_GL3oG1IIEfHPBSPhEn_fNwbQXQ-ABAbV4yM2eqoN',
                        title: title.value,
                        body: body.value
                    );
                    formKey.currentState!.reset();
                  },
                )
              ],
            ),
          ),
        );
      }

    );
  }

}