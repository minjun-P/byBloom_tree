import 'package:bybloom_tree/pages/mission_page/pages/mission2/mission2_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionSurvey extends GetView<Mission2Controller> {
  final String title;
  const MissionSurvey({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Text(title),
          ),
          _buildBar(1,'모세',0.1),
          _buildBar(2,'아브라함',0.2),
          _buildBar(3,'바울',0.5),
          _buildBar(4,'야곱',0.2)
        ],
      ),
    );
  }
  Widget _buildBar(int index, String title,double percent) {
    GlobalKey _key = GlobalKey(debugLabel: '$index번 survey');
    return GestureDetector(
      onTap: (){
        controller.selected(index);
      },
      child: Obx(()=>Stack(
        children: [
          AnimatedContainer(
            key: _key,
            height: 60,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                color: controller.selected.value==index?Colors.blue.shade200:Colors.grey.shade200
            ),
            duration: const Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(index.toString()),
                Text(title)
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: percent,
                child: AnimatedOpacity(
                  opacity: controller.submitted.value?0.4:0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                        color: Colors.black38
                    ),
                    height: 60,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      ),
    );
  }
}
