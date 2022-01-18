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

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit => 반응형 사이즈 위한 위젯. 최상위 위젯으로 만들어준다
    return ScreenUtilInit(
      designSize: Size(410,680),
      builder: () => GetMaterialApp(
        title: 'byBloom_tree',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialBinding: BindingsBuilder.put(()=>MainController()),
        home: MainScreen(),
      ),
    );
  }
}
