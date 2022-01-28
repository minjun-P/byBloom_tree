import 'dart:math';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:bybloom_tree/pages/forest_page/forest_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForestDetailPage extends GetView<ForestController> {
  ForestDetailPage({Key? key}) : super(key: key);
  Forest forest = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(246, 242, 211, 1),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(forest.title),
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
            children: [
              Hero(
                child: Image.asset('assets/tree.png'),
                tag: int.parse(Get.parameters['uid']!),
              ),
              Text('이번주 숲 목표',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 5,),
              _buildMissionContainer(),
              SizedBox(height: 5,),
              Text('숲 멤버',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFriendCircle(),
                    _buildFriendCircle(),
                    _buildFriendCircle(),
                    _buildFriendCircle(),
                    _buildFriendCircle(),
                    _buildFriendCircle()
                  ],
                ),
            )
            ]
          ),
        )
    );
  }
  Widget _buildFriendCircle() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 0.3),
              border: Border.all(color: Colors.green,width: 3)
          ),
          height: 70,
          width: 70,
          margin: EdgeInsets.symmetric(horizontal: 10)
        ),
        Text('민준')
      ],
    );
  }
  Widget _buildMissionContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //명시적으로 text가 차지할 영역 정해주기
              width: Get.width*0.6,
              padding: EdgeInsets.only(left: 40),
              child: Text('5분 기도하기')
          ),
          SizedBox(width: Get.width*0.1),
          _buildMissitonCompleteBox(),
          SizedBox(width: Get.width*0.1,)

        ],
      ),
    );
  }

  Widget _buildMissitonCompleteBox() {
    return Obx(()=>GestureDetector(
      onTap: (){
        controller.updateMissionComplete();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: controller.complete.value?33:32,
        height: controller.complete.value?33:32,
        decoration: BoxDecoration(
          border: controller.complete.value
              ?Border.all(color:Colors.green,width: 2)
              :Border.all(color:Colors.grey,width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        curve: Curves.linearToEaseOut,
        child: controller.complete.value?Icon(Icons.park,color: Colors.green,):null,

      ),
    ));
  }
}
