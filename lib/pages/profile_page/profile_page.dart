import 'package:bybloom_tree/pages/tree_page/components/tree.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const[
          Icon(Icons.message,color: Colors.black,size: 30,),
          SizedBox(width: 20,)
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 50,
            ),
            const SizedBox(height: 10,),
            const Text('박민준',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            SizedBox(
              width: Get.width*0.8,
              child: const Text(
                '안녕하세요 시민의교회 이여온입니다! 찬양부와 미디어 팀에서'
                    '봉사하고 있어요.',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const SizedBox(
                height: 250,
                width: 250,
                child: FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.fitWidth,
                    child: Tree()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
