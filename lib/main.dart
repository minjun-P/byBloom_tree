
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_detail_page/forest_detail_page.dart';

import 'package:bybloom_tree/auth/signup_page.dart';
import 'package:bybloom_tree/pages/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'auth/login_page.dart';
import 'main_controller.dart';
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_)=>runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: [
          GetPage(name: '/main', page:()=> MainScreen()),
          GetPage(name: '/login', page:()=> loginScreen()),
          GetPage(name: '/forest_detail/:uid', page: () => ForestDetailPage(),binding: BindingsBuilder.put(()=>ForestController())),
          GetPage(name:'/signup', page:()=>RegisterPage()),
          GetPage(name: '/chat', page:()=> chatpage())
        ],
        title: 'byBloom MVP',
        initialBinding: BindingsBuilder.put(() => MainController()),
        initialRoute: auth.currentUser!=null ? '/main':'/login',
        home: MainScreen(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              titleSpacing: 40,
              toolbarHeight: 60,
              iconTheme: IconThemeData(
                  color: Colors.grey
              )
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 16),
            headline1: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.black),
            headline2: TextStyle(fontWeight: FontWeight.w400,fontSize: 22,color: Colors.grey)
          )
        ),
    );
  }
}
