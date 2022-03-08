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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('김이랑',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                              Text('초보 농작꾼',style: TextStyle(color: Color(0xffC5B785)),)
                            ],
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
