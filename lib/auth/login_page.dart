import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'authservice.dart';

Map<String,dynamic>? s={'아이디':'','비밀번호':'','닉네임':'','비밀번호확인':''};


class loginScreen extends StatelessWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: ListView(
          children: [
            _loginIconBuilder('로그인하기', 150),
            LoginForm(),
            ElevatedButton(onPressed: (){Get.toNamed('/Main');}, child: Text('로그인 귀찮아')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('계정이 없다면?'),
                TextButton(
                  child: Text('회원가입'),
                  onPressed: () {
                    // 라우팅 - Get으로 변경
                    Get.toNamed('/Register');
                  },
                )
              ],
            )


          ],
        ),
      ),
    );
  }
}
Widget _loginIconBuilder(String title, double size) {
  return Column(
    children: [
      Text('ByBloom',style: TextStyle(fontSize: size/3,color: Colors.lightBlueAccent),),
      Text(
        title,
        style: TextStyle(fontSize: size/4, fontWeight: FontWeight.bold),
      )

    ],
  );
}

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);
  String? email;
  String? password;
  String? nickname;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(type: '아이디'),
          CustomTextField(type: '비밀번호'),
          SizedBox(height: 10,),
          TextButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                User? suc= await authservice.signin(s!['아이디'],s!['비밀번호']);
                if(suc!=null){
                  // get으로 네비게이터 변경
                  Get.offNamed('/main');
                } else{
                  Get.defaultDialog(
                      title: "로그인 오류",
                      textConfirm: '확인',
                      onConfirm: () => Get.back(),
                      middleText: "계정 정보가 일치하지 않습니다."
                  );
                }
              }
            },
            child: Container(
              height: 50,
              width: 200,
              child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 20),),
              alignment: Alignment(0,0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black
              ),

            ),

          )
        ],
      ),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final String type;

  const CustomTextField({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
              labelText: type,
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          validator: (value) => value!.isEmpty?'$type이 입력되지 않았습니다':null,
          obscureText: type=='비밀번호' || type=='비밀번호 확인'?true:false,
          onSaved:(value){ s![type]=value;}

      ),
    );
  }
}
