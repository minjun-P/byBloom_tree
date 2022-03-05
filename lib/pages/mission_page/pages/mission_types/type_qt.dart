import 'package:flutter/material.dart';

class Qt extends StatefulWidget {
  const Qt({Key? key}) : super(key: key);

  @override
  _QtState createState() => _QtState();
}

class _QtState extends State<Qt> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 170,left: 20,right: 20,bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('인기순'),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('세요나프레', style: TextStyle(color: Colors.grey),),
                                Text('아멘'),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.event,color: Colors.grey,),
                                    Text(index.toString(),style: TextStyle(color: Colors.grey),)
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 2,);
                  },
                  itemCount: 20
              ),
            ),

          ],
        )
    );
  }
}
