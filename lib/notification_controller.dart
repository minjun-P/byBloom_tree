import 'package:bybloom_tree/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationController extends GetxController {
  // 메시징 서비스 기본 객체 생성
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() async{
    // TODO: implement onInit
    /// 첫 빌드시, 권한 확인하기
    /// 아이폰은 무조건 받아야 하고, 안드로이드는 상관 없음. 따로 유저가 설정하지 않는 한,
    /// 자동 권한 확보 상태
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // 한번 이걸 프린트해서 콘솔에서 확인해봐도 된다.
    print(settings.authorizationStatus);
    _onMessage();
    super.onInit();
    /// 임시로 precache해보기
    precacheImage(AssetImage('assets/tree/background_3.jpg'), Get.context!);


  }
  /// ----------------------------------------------------------------------------

  /// * 안드로이드에서 foreground 알림 위한 flutter_local_notification 라이브러리 *
  ///
  /// 1. channel 생성 (우리의 알림을 따로 전달해줄 채널을 직접 만든다)
  /// 2. 그 채널을 우리 메인 채널로 정해줄 플러그인을 만들어준다.
  /// - 준비 끝!!
  // 1.
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  // 2.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void _onMessage() async{
    /// * local_notification 관련한 플러그인 활용 *
    ///
    /// 1. 위에서 생성한 channel 을 플러그인 통해 메인 채널로 설정한다.
    /// 2. 플러그인을 초기화하여 추가 설정을 해준다.

    // 1.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // 2.
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/launcher_icon'), iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {});

    /// * onMessage 설정 - 이것만 설정해줘도 알림을 받아낼 수 있다. *

    // 1. 콘솔에서 발송하는 메시지를 message 파라미터로 받아온다.
    /// 메시지가 올 때마다 listen 내부 콜백이 실행된다.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // android 일 때만 flutterLocalNotification 을 대신 보여주는 거임. 그래서 아래와 같은 조건문 설정.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description
              ),
            ),

            // 넘겨줄 데이터가 있으면 아래 코드를 써주면 됨.
            // payload: message.data['argument']
        );
      }
      // 개발 확인 용으로 print 구문 추가
      print('foreground 상황에서 메시지를 받았다.');
      // 데이터 유무 확인
      print('Message data: ${message.data}');
      // notification 유무 확인
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }
    });
    /// Background 상태. Notification 서랍에서 메시지 터치하여 앱으로 돌아왔을 때의 동작은 여기서.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rm) {
      // 첫 인덱스로 돌아가게 만들기!!
      Get.find<MainController>().navigationBarIndex(0);
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('백그라운드에서 알림 누르고 들어왔을 때'),
          );
        }
      );
    });
    // Terminated 상태에서 도착한 메시지에 대한 처리
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return AlertDialog(
              title: Text('종료상태에서 알림 누르고 들어왔을 때'),
            );
          }
      );
    }
  }

}