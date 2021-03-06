import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:bybloom_tree/pages/profile_page/tab_pages/profile_worship.dart';
import 'calendar/calendar_controller.dart';
import 'tab_pages/profile_gallery.dart';
import 'tab_pages/profile_record.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return ProfilePageState();
  }
}
class ProfilePageState extends State<ProfilePage>{

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
                              height: 120,
                              color: const Color(0xffFFF9C3),
                            ),
                            Container(
                              height: 120,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Obx(()=>
                          Positioned(
                            child: DbController.to.currentUserModel.value.profileImage==''
                                ?CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                            ):Image.asset(
                                  'assets/profile/${DbController.to.currentUserModel.value.profileImage}.png',
                              width: 120,
                              fit: BoxFit.fitWidth,
                              ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Obx(()=>
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(DbController.to.currentUserModel.value.name,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                Text(DbController.to.currentUserModel.value.nickname,style: const TextStyle(color: Color(0xffC5B785)),)
                              ],
                            ),
                          )
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
                      child: Text('??????',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                    Tab(
                      child: Text('????????????',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                    Tab(
                      child: Text('???????????????',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileRecord(),
                    ),
                    ProfileGallery(),
                    ProfileWorship()
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
