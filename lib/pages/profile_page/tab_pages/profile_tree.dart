import 'package:flutter/material.dart';

import '../../tree_page/components/tree.dart';

class ProfileTree extends StatelessWidget {
  const ProfileTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('이랑님의 나무는',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '보라색을 가진 나무',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(text: '입니다',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                ]
              )
            ),
          ],
        ),
        const SizedBox(height: 30,),
        ClipRRect(
            child: SizedBox(child: Tree()),
          borderRadius: BorderRadius.circular(40),
        )
      ],
    );
  }
}
