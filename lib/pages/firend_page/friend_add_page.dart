import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController textfield=TextEditingController();
class FriendAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return FriendState();
  }

}

class FriendState extends State<FriendAddPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
                padding:EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                    border: Border.fromBorderSide(BorderSide(color:Colors.grey ,style: BorderStyle.solid,width: 3),
                    )
                ),
                width: Get.width*0.7,
                child: Row(
                  children: [
                    Icon(Icons.search),
                    TextFormField(
                      decoration: InputDecoration(

                          labelText: "친구의 번호를 입력하세요"
                      ),
                      controller: textfield
                    ),
                  ],
                ))
          ],

        ),
      ),

    );
  }

}