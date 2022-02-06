
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class chatpage extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
         title:Text('채팅방'),

       ),


     body: Container(
       child:Text('chatpage'),
       alignment: Alignment.center,
   )
   );
  }
}