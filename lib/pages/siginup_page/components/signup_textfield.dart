import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

/// 특별한 로직은 없고 디자인 파라미터 계속 쓰자니 코드가 넘 길어지고 드러워서
/// 걍 커스텀 위젯으로 만들어 놓음. TextFormField 기반
class SignupTextField extends GetView<SignupController> {
  const SignupTextField({
    Key? key,
    required this.textController,
    required this.keyboardType,
    required this.validator,

    required this.labelText,
    this.hintText,
    this.helperText,
    this.focusNode,
    this.inputFormatters,
    this.textInputAction

  }) : super(key: key);
  // 파라미터 타입 선언
  final TextEditingController textController;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: Colors.lightGreen,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        filled: true,
        hintText: hintText,
        labelText: labelText,
        floatingLabelStyle: const TextStyle(color: Colors.lightGreen),
        helperText: helperText,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.lightGreenAccent)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.lightGreen,width: 2),
            borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}
