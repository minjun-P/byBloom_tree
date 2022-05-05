import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';

TextEditingController textfield=TextEditingController();
class FriendAddPage extends StatefulWidget{
  const FriendAddPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FriendState();
  }

}

class FriendState extends State<FriendAddPage>{

   FriendState({
     Key? key,
   }):super();
   var friendtoadd;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F4F6),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
                padding:EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                    color: Colors.white,
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
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '친구 검색하기',
                          border: InputBorder.none
                        ),
                        controller: textfield,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 30,),
            FutureBuilder<List<Contact>?>(
              future: getPermission(),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Center(child: Text('error'));
                }
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                if (snapshot.data==null){
                  return Center(child: Text('권한 허용이 안되었거나 연락처 정보에 오류가 있어요'));
                }
                var phoneList = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: phoneList.length,
                    itemBuilder: (context, index){
                      if (phoneList[index].phones!.isNotEmpty){
                        return ListTile(
                          title: Text(phoneList[index].displayName!),
                          subtitle: Text(phoneList[index].phones![0].value!),
                        );
                      }else{
                        return Container();
                      }


                    },
                  ),
                );
              },
            )
            ,

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
              ),
      )
    );



  }

}