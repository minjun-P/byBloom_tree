import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'main_controller.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit => 반응형 사이즈 위한 위젯. 최상위 위젯으로 만들어준다
    return ScreenUtilInit(
      designSize: Size(410,680),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => GetMaterialApp(
        title: 'byBloom_tree',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialBinding: BindingsBuilder.put(()=>MainController()),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: MainScreen(),
          );
        },
      ),
    );
  }
}
