import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForestPage extends StatelessWidget {
  const ForestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:

          Container(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: ListView(
            children: List.generate(6, (index) => _buildForestContainer(index))
        ),
      ),

    );
  }

  Widget _buildForestContainer(int index) {
    return InkWell(
        child:Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 0.8.sw,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:<Widget>[
        CircleAvatar(backgroundColor: Colors.lightGreen,),
        Text('$index번 숲'),
    ]
      )
    ),
            onTap:(){ Get.toNamed('/chat');} ,
            onLongPress: (){},
    );
  }
}