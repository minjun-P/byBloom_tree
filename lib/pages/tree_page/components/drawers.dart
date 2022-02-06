import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCustomDrawer({required Widget child, bool left=true}){
  return Drawer(
    backgroundColor: Colors.grey[200],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        //좌측이냐 아니냐 따라서 값 다르게 매기기
        topRight: left?const Radius.circular(30):Radius.zero,
        bottomRight: left?const Radius.circular(30):Radius.zero,
        topLeft: left?Radius.zero:const Radius.circular(30),
        bottomLeft: left?Radius.zero:const Radius.circular(30),
      )
    ),
    child: child,
  );
}

class FriendDrawer extends StatelessWidget {
  const FriendDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        const ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
          ),
          title: Text(
            '조수민',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
          ),
          trailing: Text(
            '프로필 변경하기',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              decoration: TextDecoration.underline
            ),),
        ),
        const SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('내 친구 목록', style: TextStyle(color: Colors.grey, fontSize: 14),),
            Row(
              children: const [
                Icon(Icons.search, color: Colors.grey,),
                Text('우리교회 검색',style: TextStyle(color: Colors.grey, fontSize: 14),)
              ],
            )
          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: List.generate(10, (index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                dense: true,
                title: Row(
                  children: const [
                    Text('박민준',style: TextStyle(fontSize: 18),),
                    SizedBox(width: 30,),
                    Icon(Icons.message_outlined)
                  ],
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.redAccent[200],
                ),
              );
            })
          ),
        )
      ],
    );
  }
}

class NoticeDrawer extends StatelessWidget {
  const NoticeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: List.generate(20, (index) => Container(
          height: 50,
          width: double.infinity,
          color: index.isEven?Colors.grey[500]:Colors.grey[200],
        )),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}

