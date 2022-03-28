import 'package:bybloom_tree/auth/FriendModel.dart';
import 'package:bybloom_tree/pages/tree_page/tree_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bybloom_tree/auth/User.dart';
Future<List<FriendModel>?>  findfriendwithcontact() async {
  User? curuser= FirebaseAuth.instance.currentUser;

   List<Contact>? mycontacts=await getPermission( );
    List<FriendModel> friendalreadysignedup=[];
       print("length:${mycontacts?.length}");
      for(int i=0;i<mycontacts!.length;i++) {
        for(int j=0;j<mycontacts[i].phones!.length;j++){
          String phonenumber=mycontacts[i].phones![j].value as String;
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


