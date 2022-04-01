import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calendar/calendar_controller.dart';
import 'tab_pages/profile_gallery.dart';
import 'tab_pages/profile_record.dart';
import 'tab_pages/profile_tree.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bybloom_tree/Profile/profilephoto.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return ProfilePageState();
  }
}
class ProfilePageState extends State<ProfilePage>{
  late SharedPreferences _prefs;

  @override
  initState(){
    _loadURLfromshared();
  }

  _loadURLfromshared() async {
    _prefs= await SharedPreferences.getInstance();
    downloadURL= (_prefs.getString('downloadURL') ?? await _loadURLfromdatabase()) as String?;
    _prefs.setString('profileUrl', downloadURL!);
    print('downloadURL1:$downloadURL');
  }
  Future<String?> _loadURLfromdatabase() async {
    var document= await database.collection('users').doc(curuser?.uid).get();
    return document.data()!['profileUrl'];
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());
    Get.put(ProfileController());
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 150,
                              color: Color(0xffFFF9C3),
                            ),
                            Container(
                              height: 150,
                              color: Colors.white,
                            )
                          ],
                        ),
                        ClipOval(
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                              if (snapshot.hasError){
                                return Text('error');
                              }
                              if (snapshot.hasData && !snapshot.data!.exists){
                                return Text('Document does not exist');
                              }
                              if (snapshot.connectionState == ConnectionState.done){
                                return InkWell(
                                    child: (snapshot.data!.data() as Map<String,dynamic>)['imageUrl']==''? CircularProgressIndicator(): CircleAvatar(
                                      backgroundImage:
                                      ExtendedNetworkImageProvider((snapshot.data!.data() as Map<String,dynamic>)['imageUrl'],cache: true,scale:1),

                                      radius: 80,
                                    ),
                                    onDoubleTap:(){
                                    print(downloadURL);
                                    } ,
                                    onLongPress: () {

                                    showDialog(context: context,
                                    builder: (context) {
                                    return AlertDialog(

                                    elevation: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 5,
                                    content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                    Text('프로필변경')
                                    ],
                                    ),
                                    actions: <Widget>[
                                    TextButton(onPressed: () {
                                    AddProfilePhoto();
                                    _prefs.setString("profileUrl", downloadURL!);

                                    Navigator.pop(context);
                                    }, child: Text('예')),
                                    TextButton(onPressed: () {
                                    Navigator.pop(context);
                                    }, child: Text('아니오'))
                                    ],
                                    );
                                    });
                                    }
                                    ,
                            );
                            };
                            return CircularProgressIndicator();
                                        }
                           )
                        ),
                        Positioned(
                          bottom: 20,
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError){
                                return Text('error');
                              }
                              if (snapshot.hasData && !snapshot.data!.exists){
                                return Text('Document does not exist');
                              }
                              if (snapshot.connectionState == ConnectionState.done){
                                Map<String,dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(data['name'],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                    Text(data['nickname'],style: TextStyle(color: Color(0xffC5B785)),)
                                  ],
                                );
                              }
                              return CircularProgressIndicator();

                            }
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(
                      child: Text('나무',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                    Tab(
                      child: Text('기록',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                    Tab(
                      child: Text('갤러리',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileTree(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileRecord(),
                    ),
                    ProfileGallery()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
