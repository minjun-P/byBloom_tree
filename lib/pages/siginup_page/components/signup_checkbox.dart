import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../signup_controller.dart';

class SignupCheckbox extends GetView<SignupController> {
  SignupCheckbox({
    Key? key,
    required this.rxValue,
    required this.title,
  }) : super(key: key);
  Rx<bool> rxValue;
  String title;

  @override
  Widget build(BuildContext context) {
    return Obx(()=>SizedBox(
      width: 150,
      child: CheckboxListTile(
        title: Text(title),
        dense: false,
        value: rxValue.value,
        onChanged: (value){
          rxValue(value);
        },
        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity,vertical: VisualDensity.minimumDensity),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ));
  }
}
