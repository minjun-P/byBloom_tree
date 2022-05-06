import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:bybloom_tree/auth/FriendAdd.dart';

TextEditingController textfield=TextEditingController();
class ContactFriendPage extends StatefulWidget{
  ContactFriendPage({
    Key? key,

  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ContactFriendState();
  }


}

class ContactFriendState extends State<ContactFriendPage> {
  FriendModel? friendtoadd = null;
  List<FriendModel> realpossiblefriends = [];

  ContactFriendState({
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
                    child: Text('아직가입한친구가없네요'),
                  ),


                ]

            )
        )
    );
  }
}


