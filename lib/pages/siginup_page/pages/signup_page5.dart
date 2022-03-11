import 'package:bybloom_tree/pages/siginup_page/components/signup_checkbox.dart';
import 'package:bybloom_tree/pages/siginup_page/components/signup_gauge.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


import 'signup_page6.dart';

/// 직분, 교회 활동 적극도 정도
class SignupPage5 extends GetView<SignupController> {
  const SignupPage5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 25),
          child: ListView(
            children: [
              const SignupGauge(minusWidth: 0),
              const SizedBox(height: 30,),
              const Text('교회에서 직분을 맡고 계신가요?',style: TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 20,),
              Container(
                width: 300,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)
                ),
                alignment: Alignment.topCenter,
                child: Wrap(
                  children: [
                    SignupCheckbox(
                        rxValue: controller.checked1,
                        title: '권사'
                    ),
                    SignupCheckbox(
                        rxValue: controller.checked2,
                        title: '집사'
                    ),
                    SignupCheckbox(
                        rxValue: controller.checked3,
                        title: '장로'
                    ),
                    SignupCheckbox(
                        rxValue: controller.checked4,
                        title: '셀장'
                    ),
                    SignupCheckbox(
                        rxValue: controller.checked5,
                        title: '선교사'
                    ),

                  ],
                )
              ),
              const SizedBox(height: 20,),
              const Text('교회 활동에 얼마나 적극적이신가요?',style: TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 20,),
              Container(
                  width: 300,
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.topCenter,
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('매우 소극적'),
                            Text('매우 적극적')
                          ],
                        ),
                      ),
                      Obx(()=>Slider(
                        value: controller.sliderValue.value,
                        onChanged: (value){
                          controller.sliderValue(value);
                        },
                        max: 100,
                        divisions: 5,
                        label: controller.sliderValue.toString(),
                      )),
                    ],
                  ) ,
              ),
              const SizedBox(height: 30,),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  child: const Text('이제 시작하기',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                  onPressed: (){
                    Get.to(()=>const SignupPage6());
                  },
                  style: OutlinedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      side: const BorderSide(color: Colors.grey,width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
