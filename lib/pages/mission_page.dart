import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('미션!'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: ListView(
          children: List.generate(6, (index) => _buildMissionContainer(index))
        ),
      ),
    );
  }

  Widget _buildMissionContainer(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 0.8.sw,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(20)
      ),
      alignment: Alignment.center,
      child: Text('$index번 미션'),
    );
  }
}
