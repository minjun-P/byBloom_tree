
import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/signup_page.dart';
import 'package:bybloom_tree/auth/login_controller.dart';
import 'package:bybloom_tree/notification_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'auth/login_page.dart';
import 'main_controller.dart';
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/siginup_page/pages/signup_page1.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;




FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 파이어베이스 서비스 객체 초기화
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  // 국제화 사용하기 위해선 date formatting 필수
  initializeDateFormatting().then((_)=>runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics),],

      // overScroll 시 생기는 파란색 glow를 지워주기 위함. 전역적으로 해당 설정을 적용하는 코드
      // 맨 아래 정의한 class를 참고하자!
        builder: (context, child) {


          return ScrollConfiguration(
              behavior: MyScrollBehavior(), child: child!);
        },

        // 페이지 목록 - 여기서 initial binding 즉, 종속성 주입도 같이 해주면 된다.
        getPages: [
          GetPage(name: '/main', page:()=> const MainScreen(),bindings: [BindingsBuilder.put(()=>MainController(),permanent: true),BindingsBuilder.put(()=>DbController(),permanent: true) ]),
          GetPage(name: '/login', page:()=> loginScreen(),binding: BindingsBuilder.put(()=>LoginController())),
          GetPage(name:'/signup', page:()=>RegisterPage()),
          // 회원 가입 첫 화면
          GetPage(name:'/first', page: () => const SignupPage1()),
        ],

        title: 'byBloom MVP',
      /// initialRoute를 설정할 때는 따로 home 파라미터를 설정해 주지 않아도 된다.
      /// 로그인이 안되어 있으면 회원가입 첫 화면으로 이동하게 해놨음. - 로그인 화면은 여기서 또 이동 버튼 만들어 놓음

        initialRoute: auth.currentUser != null ? '/main' : '/first',
      initialBinding: BindingsBuilder.put(()=>NotificationController(),permanent: true),
      // 나중에 디자인이 픽스되면 한번 갈아 엎어야 할 듯.
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              titleSpacing: 40,
              toolbarHeight: 60,
              iconTheme: IconThemeData(
                  color: Colors.grey
              )
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 16),
            headline1: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.black),
            headline2: TextStyle(fontWeight: FontWeight.w400,fontSize: 22,color: Colors.grey)
          ),
        ),
    );
  }
}

/// ListView에서 overScroll 시 생기는 파란색 glow를 지워주기 위함. 전역적으로 해당 설정을 적용하는 코드.
/// 굳이 알 필요 없다. 그냥 무시하면 됨.
class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}