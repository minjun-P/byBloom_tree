import 'package:bybloom_tree/pages/mission_page/pages/mission1_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionTextForm extends GetView<Mission1Controller> {
  const MissionTextForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Q1. 말씀을 듣고 느낀 점을 적어주세요'),
                SizedBox(height: 10,),
                TextFormField(
                  maxLines: 4,
                  maxLength: 100,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Q2. 하나를 골라주세요'),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(5),
                  
                  child: Wrap(
                    children: [
                      _buildQuestionChoice(1),
                      _buildQuestionChoice(2),
                      _buildQuestionChoice(3),
                      _buildQuestionChoice(4),



                    ],
                  ),
                )

              ],
            ),
          ),
        ),


        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: (){
              Get.find<Mission1Controller>().updateSubmitted();
            },
            child: Text('제출'),
          ),
        )
      ],
    );
  }
  Widget _buildQuestionChoice(int index) {
   
    return Obx(()=>Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
              value: Choice.values[index],
              groupValue: controller.choiceChecked.value,
              onChanged: (value){
                controller.choiceChecked(Choice.values[index]);
              },
            ),
            Text('$index번'),

          ],
        ),
      ),
    );
  }
}