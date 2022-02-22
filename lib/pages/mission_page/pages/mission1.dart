import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 일일 미션 1 - 묵상, deep한 미션
class Mission1 extends StatelessWidget {
  const Mission1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: Get.width*0.05),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                    '창세기 1장 1절. 태초에 하나님이 천지를 창조하시니라'
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildQuestion(),
                    _buildQuestion(),
                    _buildQuestion()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildQuestion() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200
      ),
      child: Column(
        children: [
          Text('Q1. 질문질문질문입ㄴ디ㅏ'),
          TextFormField(),
        ],
      ),
    );
  }
}
