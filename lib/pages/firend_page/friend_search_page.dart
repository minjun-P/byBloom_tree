import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FriendSearchPage extends StatelessWidget {
  const FriendSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.blue,
                    icon: Icon(Icons.search),
                    hintText: '친구 검색하기',
                    border: InputBorder.none
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text('원하는 친구가 없으시면', style: TextStyle(color: Colors.grey),),
            Text('초대링크를 클립보드에 복사해보세요', style: TextStyle(color: Colors.grey)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: CircleAvatar(backgroundColor: Colors.grey,),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('진가영'),
                          Text('010-4222-2568',style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(MdiIcons.accountPlus),
                        onPressed: (){},
                      ),
                    );
                  },
                  itemCount: 7,
                  )
              ),
          ],
        ),
      ),
    );
  }
}
