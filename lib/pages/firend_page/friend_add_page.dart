import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';

TextEditingController textfield=TextEditingController();
class FriendAddPage extends StatefulWidget{
  FriendAddPage({
    Key? key,

  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FriendState();
  }


}

class FriendState extends State<FriendAddPage> {
  FriendModel? friendtoadd = null;
  List<FriendModel> realpossiblefriends = [];

  FriendState({
    Key? key,
  }) :super();

  @override
  void initState() {
    super.initState();
    if (DbController.to.possiblefriends != null) {
      DbController.to.possiblefriends!.forEach((element) {
        if ((!DbController.to.currentUserModel.value.friendPhoneList.contains(
            element.phoneNumber))&&DbController.to.currentUserModel.value.phoneNumber!=element.phoneNumber)  {
          realpossiblefriends.add(element);
        }
      });
    }
    print(DbController.to.possiblefriends);
    print(realpossiblefriends.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("친구검색"),),
        body:
        Container(

            width: Get.width,


            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.all(
                              Radius.circular(20)),
                          border: Border.fromBorderSide(BorderSide(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 3),
                          )
                      ),
                      width: Get.width * 0.7,
                      child: Row(
                        children: [
                          InkWell(

                            child: Icon(Icons.search),
                            onTap: () async {
                              if (textfield.text.length == 11) {
                                friendtoadd =
                                await findUserFromPhone(textfield.text);
                              }
                              else {
                                friendtoadd =
                                await findUserFromName(textfield.text);
                              }
                              setState(() {


                              });
                            },
                          ),
                          SizedBox(
                            width: Get.width * 0.5,
                            child: TextFormField(
                              decoration: InputDecoration(

                                  labelText: "친구의 번호나 이름을 검색해보세요"
                              ),
                              controller: textfield,
                            ),
                          ),
                        ],
                      )),
                  realpossiblefriends!.length != 0 ? Container(
                    height: Get.height * 0.4,
                    child: ListView.builder(

                        padding: const EdgeInsets.symmetric(horizontal: 10),

                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              realpossiblefriends![index].name,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                            leading: Image.asset(
                                'assets/profile/${ realpossiblefriends![index]
                                    .profileImage}.png'),

                            trailing: InkWell(
                              onTap: () {
                                AddFriend(realpossiblefriends[index]);
                              },
                              child: Icon(Icons.person_add,
                                color: Colors.grey.shade500,),
                            ),
                          );
                        }, itemCount: realpossiblefriends!.length
                    ),
                  ) : Container(
                    height: Get.height*0.4,
                    child: Text('아직가입한친구가없네요'),
                  ),


                  SizedBox(
                    height: 100,
                  ),


                  Container(
                      child:
                      friendtoadd == null ? Text("아직 가입하지 않은 친구네요.") :


                      Container(
                        width: Get.width * 0.7,
                        height: Get.width * 0.3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(20)),
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 3))
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(

                                    children: [
                                      CircleAvatar(backgroundColor: Colors.lime,
                                        radius: 30,),
                                      SizedBox(width: 20),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text("${friendtoadd!.name}"),
                                          Text(friendtoadd!.phoneNumber,
                                            style: TextStyle(
                                                color: Colors.grey),)
                                        ],
                                      )
                                    ]
                                ),
                                InkWell(
                                  onTap: () {
                                    AddFriend(friendtoadd!);
                                    Fluttertoast.showToast(
                                        msg: "${friendtoadd!
                                            .name}님 친구추가가 완료되었습니다.",
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
                                )
                              ]
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


