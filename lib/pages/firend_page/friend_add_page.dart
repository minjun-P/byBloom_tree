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
      backgroundColor: const Color(0xffF2F4F6),
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 친구 검색 창
              Container(
                  padding:const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                      color: Colors.white,
                      ),
                  width: Get.width*0.7,
                  child: Row(
                    children: [
                      InkWell(
                        child: const Icon(Icons.search),
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
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: '친구 검색하기',
                            border: InputBorder.none
                          ),
                          controller: textfield,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 30,),
              // 연락처 불러오기
              const Align(
                  child: Text('주소록',style: TextStyle(fontSize: 24),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                height: Get.width*0.5,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
                ),
                //
                child: FutureBuilder<List<Contact>?>(
                  future: getPermission(),
                  builder: (context, snapshot){
                    if (snapshot.hasError){
                      return const Center(child: Text('error'));
                    }
                    if (snapshot.connectionState==ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data==null){
                      return const Center(child: Text('권한 허용이 안되었거나 연락처 정보에 오류가 있어요'));
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
                ),
              ),
            const Spacer(),
            Container(
              child:
                friendtoadd==null
                    ?const Text("아직 가입하지 않은 친구네요.")
                    :SizedBox(
                      width: Get.width*0.7,
                      height: Get.width*0.3,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                          border: Border.fromBorderSide(BorderSide(color:Colors.grey ,style: BorderStyle.solid,width: 3))
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:[
                            Row(
                              children:[
                          const CircleAvatar(backgroundColor: Colors.lime,radius: 30,),
                            const SizedBox(width: 20),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${friendtoadd!.name}"),
                                Text(friendtoadd!.phoneNumber,style: const TextStyle(color: Colors.grey),)
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
                                children: const [
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
        ),
      )
    );
  }
}