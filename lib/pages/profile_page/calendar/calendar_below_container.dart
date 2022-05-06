import 'package:bybloom_tree/pages/profile_page/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calendar_controller.dart';

class CalendarBelowContainer extends GetView<CalendarController> {
  const CalendarBelowContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CalendarController>(
          builder: (controller) {
            return AnimatedSwitcher(
              // 자연스러운 위젯 전환을 위해 AnimatedSwitcher 위젯 추가!
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey<int>(controller.selectedDay.value.day),
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                decoration: const BoxDecoration(
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


                    GetBuilder<CalendarController>(
                      builder: (controller){
                        List eventsCategory = controller.getEventsForDay().map((event)=>event.category!).toList();
                        return Table(
                          children: [
                            TableRow(
                              children: [
                                Text('한줄 말씀', style: TextStyle(color: eventsCategory.contains('A')?Colors.green:Colors.black,fontSize: 20,fontWeight: eventsCategory.contains('A')?FontWeight.bold:FontWeight.w300),),
                                Text('나눔 미션', style: TextStyle(color: eventsCategory.contains('B')?Colors.green:Colors.black,fontSize: 20,fontWeight: eventsCategory.contains('B')?FontWeight.bold:FontWeight.w300),),
                              ]
                            ),
                            TableRow(
                                children: [
                                  Text('감사 일기', style: TextStyle(color: eventsCategory.contains('C')?Colors.green:Colors.black,fontSize: 20,fontWeight: eventsCategory.contains('C')?FontWeight.bold:FontWeight.w300),),
                                  Text('교회연계미션', style: TextStyle(color: eventsCategory.contains('D')?Colors.green:Colors.black,fontSize: 20,fontWeight: eventsCategory.contains('D')?FontWeight.bold:FontWeight.w300),)
                                ]
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
            ;
          },
        ),

      ],
    );
  }
}
