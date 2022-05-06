import 'package:bybloom_tree/pages/siginup_page/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'signup_page_basic_information.dart';
import 'package:url_launcher/url_launcher.dart';

/// 회원가입 첫번 째 화면, 인사하는 화면
class SignupPageMain extends StatelessWidget {
  const SignupPageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '안녕하세요!',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text.rich(TextSpan(
                text: '바이블룸',
                children: [
                  TextSpan(text: '입니다', style: TextStyle(color: Colors.grey))
                ],
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              )),
              const Spacer(),
              const Text(
                '크리스천 모두의 신앙생활에 도움이 될 나무를 가꾸고 있어요',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const Text(
                '바이블룸과 함께 아름다운 나무를 키우며 같이 성장해보아요!',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '이미 계정이 있다면?',
                    style: TextStyle(fontSize: 13),
                  ),
                  TextButton(
                    child: const Text('로그인'),
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Get.to(() => const SignupPageBasicInformation(),
                        transition: Transition.rightToLeftWithFade,
                        binding:
                            BindingsBuilder.put(() => SignupController()));
                  },
                  style: OutlinedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      side: const BorderSide(color: Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        const url1 ='https://docs.google.com/document/d/1lEKvfWf_admIM377cggo1FaFJS4KtziNAS1Q4KMIM2g/edit?usp=sharing';
                        launchUrlString(url1);
                      },
                      child: const Text('개인정보처리방침',style: TextStyle(fontSize: 13,color: Colors.grey),),
                    ),
                    TextButton(
                        onPressed: () {
                          const url2 ='https://docs.google.com/document/d/1lEKvfWf_admIM377cggo1FaFJS4KtziNAS1Q4KMIM2g/edit';
                          launchUrlString(url2);
                        },
                        child: const Text('이용약관',style: TextStyle(fontSize: 13,color: Colors.grey),)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
