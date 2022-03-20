import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calendar/calendar_controller.dart';
import 'tab_pages/profile_gallery.dart';
import 'tab_pages/profile_record.dart';
import 'tab_pages/profile_tree.dart';
import 'package:bybloom_tree/pages/tree_page/components/tree.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());
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
                          child: Container(
                            color: Colors.green,
                            height: 100,
                            width: 100,
                          ),
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
