import 'package:bybloom_tree/pages/siginup_page/components/signup_gauge.dart';
import 'package:bybloom_tree/pages/siginup_page/components/signup_textfield.dart';
import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';




import 'signup_page_profile.dart';

/// 회원가입 세번째 화면 - 직분, 교회 활동 적극도 정도
class SignupPageChurch extends GetView<SignupController> {
  const SignupPageChurch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 25),
          child: ListView(
            children: [
              const SignupGauge(minusWidth: 160),
              const SizedBox(height: 30,),
              const Text('교회를 다니고 계신가요?',style: TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 5,),
              Form(
                key: controller.pageChurchKey,
                child: SignupTextField(
                    textController: controller.churchCon,
                    keyboardType: TextInputType.text,
                    validator: (text){
                      if (text!.isEmpty){
                        return '작성 부탁려요!';
                      } else{
                        return null;
                      }
                    },
                    labelText: '교회명',
                  helperText: '다니는 교회가 없으시다면 \'없음\'으로 적어주세요!',
                ),
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



            ],
          ),
        ),
        bottomSheet: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          alignment: Alignment.center,
          child: OutlinedButton(
            child: const Text('작성완료',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
            onPressed: (){
              if (controller.pageChurchKey.currentState!.validate()){
                Get.to(()=>const SignupPageProfile());
              }

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
      ),
    );
  }
}
