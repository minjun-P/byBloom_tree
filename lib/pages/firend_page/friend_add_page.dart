import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:extended_image/extended_image.dart';
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

            Container(

              width: Get.width,
              height: Get.height*0.8,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

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
                          InkWell(

                          child:Icon(Icons.search),
                          onTap: () async {
                            if(textfield.text.length==11){
                            s=await findUserFromPhone(textfield.text);}
                            else {
                            s=await findUserFromName(textfield.text);
                            }
                            setState(() {


                            });
                          },
                          ),
                          SizedBox(
                            width:Get.width*0.5,
                            child: TextFormField(
                              decoration: InputDecoration(

                                   labelText: "친구의 번호나 이름을 검색해보세요"
                                ),
                                controller: textfield,
                              ),
                            ),
                          ],
                        )),

                SizedBox(
                  height: 100,
                ),



                Container(
                  child:
                    s==null? Text("아직 가입하지 않은 친구네요."):


                        Container(
                          width: Get.width*0.7,
                          height: Get.width*0.3,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                              border: Border.fromBorderSide(BorderSide(color:Colors.grey ,style: BorderStyle.solid,width: 3))
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Row(

                                  children:[
                              CircleAvatar(backgroundColor: Colors.lime,radius: 30,),
                                SizedBox(width: 20),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${s!.name}"),
                                    Text(s!.phoneNumber,style: TextStyle(color: Colors.grey),)
                                  ],
                                )]
                                ),
                                InkWell(
                                  onTap: (){
                                    AddFriend(s!);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_add),

                                    ],
                                  ),
                                )]
                            ),
                          ),
                        )

                    )




              ]
            )


        )
    );



  }

}