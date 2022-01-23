import 'package:bybloom_tree/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_controller.dart';
import 'main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'byBloom MVP',
        initialBinding: BindingsBuilder.put(() => MainController()),
        getPages: [  GetPage(name: '/main', page: ()=>MainScreen()),
                     GetPage(name: '/login', page: ()=>LoginScreen())
        ],
        initialRoute: '/main',

        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFf1f8f7),
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              titleSpacing: 40,
              toolbarHeight: 60,
              iconTheme: IconThemeData(
                  color: Colors.grey
              )
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)
          )
        ),
    );
  }
}
