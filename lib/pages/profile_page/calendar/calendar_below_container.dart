import 'package:bybloom_tree/pages/profile_page/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calendar_controller.dart';

class CalendarBelowContainer extends GetView<CalendarController> {
  const CalendarBelowContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarController>(
      builder: (controller) {
        return AnimatedSwitcher(
          // 자연스러운 위젯 전환을 위해 AnimatedSwitcher 위젯 추가!
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey<int>(controller.selectedDay.value.day),
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width:35,
                        height: 30,
                        child: Text('${controller.selectedDay.value.day}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                    ),
                    SizedBox(
                        width: 40,
                        height: 20,
                        child: Text(controller.getWeekDay(), style: const TextStyle(fontSize: 16,color: Colors.blueGrey),)
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                ...List.generate(controller.eventsCompleteListLength(), (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.getEventsForDay().where((event) => event.complete).toList()[index].title,
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                      Visibility(
                          child: Divider(
                            thickness: 1.4,
                          ),
                        visible: index < controller.eventsCompleteListLength()-1,
                      )
                    ],
                  );
                })

              ],
            ),
          ),
        )
        ;
      },
    );
  }
}
