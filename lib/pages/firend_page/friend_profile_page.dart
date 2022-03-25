import 'package:bybloom_tree/pages/firend_page/firend_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tree_page/components/tree.dart';

class FriendProfilePage extends GetView<FriendProfileController> {
  const FriendProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: Stack(
            children: [
              Tree(),
              Positioned(
                top: 50,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('안녕하세요',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
                    Text('이아름님의 나무입니다', style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.star,size: 40,color: Colors.white,),
                  onPressed: (){},
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 150,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),

          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '박민준',
                        style: TextStyle(
                            fontSize: 21
                        ),),
                      Text('별명')
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.start)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconWithNum(Icons.key,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(Icons.key,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(Icons.key,120),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  _buildIconWithNum(IconData icon, int num) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,size: 30,color: Colors.blueGrey,),
        SizedBox(width: 10,),
        Text(num.toString(),style: TextStyle(fontSize: 16,color: Colors.blueGrey),)
      ],
    );
  }
}

