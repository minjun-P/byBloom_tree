import 'dart:math';
import 'forest_model.dart';
import 'package:bybloom_tree/pages/forest_page/forest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForestPage extends GetView<ForestController> {
  const ForestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForestController());
    return Scaffold(
      appBar: AppBar(
        title: Text('숲',style: TextTheme().headline1,),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
            decoration: BoxDecoration(
            ),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 0.2),
                        Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 0.2)
                      ]
                    )
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('가족방',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                      Text(
                          '오늘 집에 몇시에 올겨아야? 나는 좀 늦게 들어올 것 같아. 바쁜 일이 생겼거든',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('오후 5:23',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    SizedBox(height: 5,),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child: Text('10',style: TextStyle(color: Colors.white,fontSize: 14),),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

}
