import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

TextEditingController textfield=TextEditingController();
class FriendAddPage extends StatefulWidget{
  final List<FriendModel> friendincontact;
  FriendAddPage({
    Key? key,
    required this.friendincontact
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FriendState(friendincontact: friendincontact);
  }

}

class FriendState extends State<FriendAddPage>{
   FriendModel? friendtoadd=null;
   final List<FriendModel> friendincontact;
   FriendState({
     Key? key,
     required this.friendincontact
   }):super();
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
                  friendincontact.isEmpty?Text("가입한 친구가없습니다."):Expanded(
                    child: ListView.builder(

                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            friendincontact[index].name,
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                          leading: Image.asset(
                              'assets/profile/${friendincontact[index].profileImage}.png'),

                          trailing: InkWell(
                            onTap: (){
                          AddFriend(friendtoadd!);


                            },
                            child: Icon(Icons.person_add,
                              color: Colors.grey.shade500,),
                          ),
                        );
                      }, itemCount: friendincontact.length,
                    ),
                  ),
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
                            friendtoadd=await findUserFromPhone(textfield.text);}
                            else {
                            friendtoadd=await findUserFromName(textfield.text);
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
                    friendtoadd==null? Text("아직 가입하지 않은 친구네요."):


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
                                    Text("${friendtoadd!.name}"),
                                    Text(friendtoadd!.phoneNumber,style: TextStyle(color: Colors.grey),)
                                  ],
                                )]
                                ),
                                InkWell(
                                  onTap: (){
                                    AddFriend(friendtoadd!);
                                    Fluttertoast.showToast(
                                        msg: "${friendtoadd!.name}님 친구추가가 완료되었습니다.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
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