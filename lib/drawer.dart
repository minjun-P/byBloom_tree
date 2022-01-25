import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:ListView(
       children: <Widget>[
         IconButton(onPressed: (){
           Get.toNamed('/login');
         }
         , icon: Icon(Icons.logout))
       ],
      )
    );
  }
}