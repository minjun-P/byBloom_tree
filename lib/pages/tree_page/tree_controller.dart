import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Tree 페이지의 컨트롤러
/// - 경험치 제어
/// - 나무 성장단계 제어
/// - 물받기 제어
/// 이러한 기능이 필요할 듯 하다.
class TreeController extends GetxController with GetTickerProviderStateMixin{

  late AnimationController wateringIconController;
  late AnimationController rainController;
  late Animation<double> rainAnimation;

  final List<Image> imageList = [
    Image.asset('assets/tree/background_1.jpg',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_1.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_2.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_3.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_4.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_5.png',width: Get.width,fit: BoxFit.fitWidth,),
    Image.asset('assets/tree/tree_6.png',width: Get.width,fit: BoxFit.fitWidth,),
  ];

  late GlobalKey<FormState> formKey;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

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

  @override
  void didChangeDependencies(BuildContext context) {
    // TODO: implement didChangeDependencies
    for (int i=1;i<=6;i++) {
      precacheImage(imageList[i].image, Get.context!);
    }
    super.didChangeDependencies(context);
  }

  void animateWateringIcon() async {
    await wateringIconController.forward();
    await wateringIconController.reverse();
    await rainController.forward();
    await rainController.reverse();
  }

  Rx<int> treeGrade = 1.obs;
  void treeUpgrade() {
    if (treeGrade.value == 6) {
      treeGrade(1);
    } else {
      treeGrade(treeGrade.value+1);
    }
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
                      title(text);
                    }
                ),
                ElevatedButton(
                  child: Text('에뮬레이터 보내기'),
                  onPressed: (){
                    formKey.currentState!.save();
                    formKey.currentState!.reset();
                    sendFcm(
                      token: 'fjYFENbtSXSvgPyc7bBl5p:APA91bHkyMmxFR3u56XLU7ypMA7Te4knctP3Pgb1vfI-mr8A7az5ptolz0RRrASxWlzssAbUhUVrWYDxX1cMe0WDYOfd3EgMjwEkwxqd3pqIFXvo5q3izhH5fRtr4qowgFL5B1bG7kXx',
                      title: title.value,
                      body: body.value
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('에뮬레이터 보내기'),
                  onPressed: (){

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