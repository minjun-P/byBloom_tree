import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/tree3.gif',
            height: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10,),
          Text('나의 나무',)
        ],
      ),
    );

  }
}
