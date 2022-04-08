import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';

TextEditingController textfield=TextEditingController();
class FriendAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return FriendState();
  }

}

class FriendState extends State<FriendAddPage>{
   FriendModel? s=null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("친구검색"),),
      body:

            SizedBox(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        padding:EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                            border: Border.fromBorderSide(BorderSide(color:Colors.grey ,style: BorderStyle.solid,width: 3),
                            )
                        ),
                        width: Get.width*0.7,
                        child: Row(
                          children: [
                            InkWell(

                            child:Icon(Icons.search),
                            onTap: () async {
                              s=await findUserFromPhone(textfield.text);
                              setState(() {


                              });
                            },
                            ),
                            SizedBox(
                              width:Get.width*0.5,
                              child: TextFormField(
                                decoration: InputDecoration(

                                    labelText: "친구의 번호를 검색해보세요"
                                ),
                                controller: textfield,
                              ),
                            ),
                          ],
                        )),
                  ),



                Container(
                  child:
                    s==null? Text("아직 가입하지 않은 친구네요."):

                    Row(
                      children: [
                        Text(s!.name)
                      ],
                    )
                )



              ]
            )


        )
    );



  }

}