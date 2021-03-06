import 'package:bybloom_tree/pages/profile_page/calendar/calendar.dart';
import 'package:bybloom_tree/pages/profile_page/calendar/calendar_below_container.dart';
import 'package:bybloom_tree/pages/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileRecord extends StatelessWidget {
  const ProfileRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      children: [
        _buildRecordContainer(),
        const SizedBox(height: 30,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(2,2),
                    blurRadius: 3,
                    spreadRadius: 0,
                    color: Colors.grey
                ),
              ]
          ),
          child: const Calendar(),
        ),
        const SizedBox(height: 20,),
        Container(

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(2,2),
                    blurRadius: 3,
                    spreadRadius: 0,
                    color: Colors.grey
                ),
              ]
          ),
          child: const CalendarBelowContainer(),
          clipBehavior: Clip.hardEdge,
        )
      ],
    );
  }
  Widget _buildRecordContainer(){
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                offset: Offset(2,2),
                blurRadius: 3,
                spreadRadius: 0,
                color: Colors.grey
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('?????? ??????',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
          const SizedBox(height: 10,),
          Obx(()=>
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRecordDetail('????????????', '???', Get.find<ProfileController>().missionCount.value),
                  _buildRecordDetail('????????????', '???', Get.find<ProfileController>().dayCount.value),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildRecordDetail(String title, String unit, int data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,style: const TextStyle(fontSize: 16,color: Colors.grey),),
        const SizedBox(height: 10,),
        Text.rich(
            TextSpan(
                children: [
                  TextSpan(text: data.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' $unit',style: const TextStyle(fontSize: 14, color: Colors.grey))
                ]
            )
        )
      ],
    );
  }
}
