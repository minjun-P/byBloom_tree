import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authservice.dart';

final database= FirebaseFirestore.instance;
Future<List<FriendModel>?>  findfriendwithcontact(String mynumber) async {
   List<Contact>? mycontacts=await getPermission( );
    List<FriendModel> friendalreadysignedup=[];
      for(int i=0;i<mycontacts!.length;i++) {
        for(int j=0;j<mycontacts[i].phones!.length;j++){
          String phonenumber=mycontacts[i].phones![j].value as String;
          if(phonenumber.length!=11){
            phonenumber=phonenumber.replaceAll('-', "");
            if(phonenumber.length!=11){
              phonenumber=phonenumber.substring(3);
            }
          }
         if (phonenumber!=mynumber) {
           FriendModel? s = await findUserFromPhone(phonenumber);
           if (s != null) {
             friendalreadysignedup.add(s);
           };
         }
        };
      };
      return friendalreadysignedup;
      // 허락해달라고 팝업띄우는 코드
    }
    ///스트링 formatter추가
///

Future<List<Contact>?>getPermission() async{
  var status = await Permission.contacts.status;
  if(status.isGranted){
    // 변수 가져오기!
    var contacts = await ContactsService.getContacts();
    return contacts;
  } else if (status.isDenied){
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
Future<bool> deleteFriend(FriendModel friendtoadd) async {

  if (friendtoadd!=null&& DbController.to.currentUserModel.value.friendPhoneList.contains(friendtoadd.phoneNumber)){


    DbController.to.currentUserModel.value.friendPhoneList.remove(friendtoadd.phoneNumber);
    DbController.to.currentUserModel.value.friendList.remove(friendtoadd);
    database.collection('users').doc(authservice
        .getCurrentUser()
        ?.uid).update({'friendPhoneList': DbController.to.currentUserModel.value.friendPhoneList});
    return true;
  };
  return false;
}
///친구삭제하는 로직
///
Future<FriendModel?> findUserFromPhone(String phoneNum) async {
  var friend = await FirebaseFirestore.instance.collection('users').
  where('phoneNumber', isEqualTo: phoneNum).get()
  ;

  if (friend.size != 0) {
    return FriendModel(
        name: friend.docs[0].data()['name'],
        phoneNumber: friend.docs[0].data()['phoneNumber'],
        nickname: friend.docs[0].data()['nickname'],
        exp: friend.docs[0].data()['exp'],
        level: friend.docs[0].data()['level'],
        tokens: friend.docs[0].data()['tokens']??[],
        uid: friend.docs[0].id,
        profileImage: friend.docs[0].data()['profileImage']
    );
  }
}




