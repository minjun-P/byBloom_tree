import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'main_controller.dart';
import 'main_screen.dart';


void main() {
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
        home: MainScreen(),

        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFf1f8f7),
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              titleSpacing: 40.w,
              toolbarHeight: 60.h,
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
