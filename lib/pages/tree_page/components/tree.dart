import 'package:flutter/material.dart';

class Tree extends StatelessWidget {
  const Tree({
    Key? key,
    required this.scale
  }) : super(key: key);
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffF6F4DD), Colors.yellow, Color(0xffF6F4DD)]
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
              shaderCallback: (Rect bound){
                return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white,Colors.transparent],
                    stops: [0.7,0.9]
                ).createShader(bound);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset('assets/new1.png',scale: scale,)
          ),
          Image.asset('assets/new3.png',scale: scale,)
        ],
      ),

    );
  }
}
