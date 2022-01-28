import 'package:flutter/material.dart';

class OtherTreePage extends StatelessWidget {
  const OtherTreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PageView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/tree_page${index+1}.gif'),
                SizedBox(height: 10,),
                Text('${index+1}번 나무')
              ],
            )
          );
        },

      ),
    );
  }
}
