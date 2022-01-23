import 'package:bybloom_tree/pages/other_tree_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
              height: 500,
              width: 200.sw,
              child: Image.asset('assets/tree1.gif',fit: BoxFit.cover)
          ),
      ),
    );
  }
}
