import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('미션!',textAlign:TextAlign.left,),
      ),
      body: Column(
      children:<Widget>[
      Container( height: 350.h,
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child:Column(
          children: <Widget>[
            Text('오늘의 미션',textAlign: TextAlign.left),
             Container(
               height: 300.h,
               child:
             ListView(
          children: List.generate(6, (index) => _buildMissionContainer(index))
        )
             )
        ]
        ),
      ),
     Container(
       child: Column(
         children: <Widget>[
           Text('나의기록'),
           Container(
             child: Text('달력페이지'),
             color: Colors.lime,
             height: 150.h,
             width: 350.w,
           )
         ],
       )

     )
      ]
    )
    );
  }

  Widget _buildMissionContainer(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 0.8.sw,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Text('$index번 미션'),
    );
  }
}
