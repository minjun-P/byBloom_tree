import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/Profile/profilephoto.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/tree_page/tree_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bybloom_tree/auth/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authservice.dart';
import 'package:bybloom_tree/pages/tree_page/tree_controller.dart';

final database= FirebaseFirestore.instance;
Future<List<FriendModel>?>  findfriendwithcontact() async {

   List<Contact>? mycontacts=await getPermission( );
    List<FriendModel> friendalreadysignedup=[];
       print("length:${mycontacts?.length}");
      for(int i=0;i<mycontacts!.length;i++) {
        for(int j=0;j<mycontacts[i].phones!.length;j++){
          String phonenumber=mycontacts[i].phones![j].value as String;
          print(phonenumber);
          if(phonenumber.length!=11){
            phonenumber=phonenumber.replaceAll('-', "");
            if(phonenumber.length!=11){
              phonenumber=phonenumber.substring(3);
            }
          }
          print(phonenumber);
         FriendModel? s=await findUserFromPhone(phonenumber);
         if(s!=null){
           print("added");
         friendalreadysignedup.add(s);
         };
        };
      };
      print("length:${friendalreadysignedup.length}");
      return friendalreadysignedup;

      // 허락해달라고 팝업띄우는 코드
    }
    ///스트링 formatter추가
///

Future<List<Contact>?>getPermission() async{
  var status = await Permission.contacts.status;
  if(status.isGranted){
    print('허락됨');
    // 변수 가져오기!
    var contacts = await ContactsService.getContacts();
    print(contacts[0].displayName);
    return contacts;
  } else if (status.isDenied){
    print('거절됨');
    Permission.contacts.request(); // 허락해달라고 팝업띄우는 코드
  }
}


Future<bool> AddFriendfromPhone(String phonenum) async {
  FriendModel? friendtoadd=await findUserFromPhone(phonenum);
  if (friendtoadd!=null){

     List<String>?temp=DbController.to.currentUserModel.value.friendPhoneList;
     temp.add(phonenum);


    DbController.to.currentUserModel.value.friendList.add(friendtoadd);
    database.collection('users').doc(authservice
        .getCurrentUser()
        ?.uid).update({'friendPhoneList':temp});
     return true;
  };
  return false;
}

Future<bool> AddFriend(FriendModel friendtoadd) async {

  if (friendtoadd!=null&& !DbController.to.currentUserModel.value.friendPhoneList.contains(friendtoadd.phoneNumber)){


    List<String>?temp=DbController.to.currentUserModel.value.friendPhoneList;
    temp.add(friendtoadd.phoneNumber);


    DbController.to.currentUserModel.value.friendList.add(friendtoadd);
    database.collection('users').doc(authservice
        .getCurrentUser()
        ?.uid).update({'friendPhoneList':temp});
    return true;
  };
  return false;
}

///친구추가하는 로직!!


