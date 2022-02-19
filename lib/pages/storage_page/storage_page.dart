import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/calendar.dart';
import 'pages/storage_grid.dart';

/// 저장소 페이지
/// - 그냥 저번에 만들어놨던 달력을 옮겨오기만 했음.
/// - DB 연결하면서 controller도 새로 만들어야 할 듯.
/// - scaffold body는 Sliver 라는 위젯 계열로 채웠음. 동적이고 이쁜 scroll을 만들어줌.
class StoragePage extends StatelessWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              title: const Text('기록 저장소',style: TextStyle(fontSize: 30),),
              actions: [TextButton(
                child: const Text('한번에 보기'),
                onPressed: (){
                  /// 한번에 보기 페이지로 이동 - gridVidw로 구성되어 있음.
                  Get.to(()=>const StorageGrid());
                },
              )],
              pinned: true,
              toolbarHeight: 80,
              //background가 사라지는 높이
              collapsedHeight: 90,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 100,),
                      Text.rich(TextSpan(
                          children: [
                            TextSpan(text: '수민님은, ',style: TextStyle(color: Colors.blueGrey)),
                            TextSpan(text: '256시간동안',style: TextStyle(color: Colors.grey))
                          ]
                      ),style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                      Text('89개의 미션을 해냈어요!',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.grey),)
                    ],
                  ),
                ),
              ),

            ),
            /// 달력 위젯 - 달력과 관련된 코드는 components 내부 calendar에서 관리!
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              sliver: SliverToBoxAdapter(
                child: Calendar(),
              ),
            ),

          ],
        ),
      ),
    )
      ;
  }
}