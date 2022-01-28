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
    return Container(
      color: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.fromLTRB(Get.width*0.05, 40, Get.width*0.05, 100),
        children: [
          Text('숲',style: context.textTheme.headline1,),
          Wrap(
            children: List.generate(forests.length, (index) => _buildForestContainer(index))
          ),
        ]
      )
    );
  }
  Widget _buildForestContainer(int index) {
    return GestureDetector(
      onTap: (){
        Get.toNamed('/forest_detail/${index}',arguments: forests[index]);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(Random().nextInt(255),Random().nextInt(255), Random().nextInt(255), 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white,width: 3)
            ),
            height: 300,
            width: Get.width*0.4,
            margin: EdgeInsets.fromLTRB(Get.width*0.025, Get.width*0.05, Get.width*0.025, 5),
            padding: EdgeInsets.all(8),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                          visible: forests[index].isStar,
                          child: Icon(Icons.star,color: Colors.white,size: 25,)),
                      Visibility(
                        visible: forests[index].chatCount>0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                          child: Text('${forests[index].chatCount}',style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Hero(child: Image.asset('assets/tree.png'),tag: index,)
              ],
            ),
          ),
          Text('${forests[index].title}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
