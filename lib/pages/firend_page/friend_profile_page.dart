import 'package:bybloom_tree/pages/firend_page/firend_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                child: Container(
                  padding: EdgeInsets.only(bottom: 5,left: 3,right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white,width: 4)
                  ),
                  child: IconButton(
                    icon: Icon(MdiIcons.wateringCanOutline,size: 40,color: Colors.white,),
                    onPressed: (){},
                  ),
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
                  Icon(MdiIcons.messageProcessingOutline,color: Colors.grey.shade400,size: 35,),
                  SizedBox(width: 20,)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconWithNum(MdiIcons.clockOutline,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(MdiIcons.checkboxOutline,120),
                  SizedBox(width: 40,),
                  _buildIconWithNum(MdiIcons.calendarWeekendOutline,120),
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
        Icon(icon,size: 25,color: Colors.grey,),
        SizedBox(width: 10,),
        Text(num.toString(),style: TextStyle(fontSize: 16,color: Colors.grey),)
      ],
    );
  }
}

