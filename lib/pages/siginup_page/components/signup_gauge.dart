import 'package:flutter/material.dart';

/// 회원가입 페이지 상단 게이지
/// Hero 위젯 활용해서 페이지 전환시, 매끄럽게 게이지가 차는 모습을 연출했음.
class SignupGauge extends StatelessWidget {
  const SignupGauge({
    Key? key,
    required this.minusWidth
  }) : super(key: key);
  final double minusWidth;

  @override
  Widget build(BuildContext context) {
    /// Stack 으로 한 이유는, Hero 내부에 또 Hero가 들어갈 수 없기 때문.
    return Stack(
      children: [
        // 뒷면, 회색 배경
        Hero(
          tag: 'gauge1',
          child: Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        /// 앞면 초록색 게이지
        /// 특이한 방식으로 width를 조절함. Stack과 Positioned의 특성을 활용
        /// left:0 right:0을 주면 형제 위젯의 크기를 모두 채움. 그래서
        /// right 값만 조절하는 방식으로 게이지 width를 조절
        Positioned(
          left: 0,
          right: minusWidth,
          child: Hero(
            tag: 'gauge2',
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ],
    );
  }
}
