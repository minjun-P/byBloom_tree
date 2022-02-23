import 'package:bybloom_tree/pages/mission_page/pages/components/mission_textformfield.dart';
import 'package:bybloom_tree/pages/mission_page/pages/mission1_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 일일 미션 1 - 묵상, deep한 미션
class Mission1 extends GetView<Mission1Controller> {
  Mission1({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Get.put(Mission1Controller());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: controller.submitted.value
          ?FloatingActionButton(
          child: Text('제출'),
          onPressed: (){
            controller.updateSubmitted();
          },
        )
        :null,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: Get.width*0.05),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '여기는 미션이 들어가잘 자리입니다. /////////////////////////////////////////////////////////////////////////'
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
              Expanded(
                child: Obx(()=> AnimatedSwitcher(
                      child: controller.submitted.value
                      // 질문 칸
                          ?SingleChildScrollView(
                        key: ValueKey(0),
                        child: _buildFeed(),
                      )
                      // 질문 제출 시, 답 목록 피드
                          :SingleChildScrollView(
                        key: ValueKey(1),
                        child: MissionTextForm(),
                      ),
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildFeed() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        return GestureDetector(
          onTap: (){
            controller.submitted(!controller.submitted.value);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.all(10),
            child: Text('$index: 다른사람들 답'),
          ),
        );
      })
    );
  }
}
