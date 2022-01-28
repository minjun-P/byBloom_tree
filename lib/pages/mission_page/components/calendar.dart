import 'package:bybloom_tree/pages/mission_page/components/calendar_controller.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'calendar_model.dart';

class Calendar extends GetView<CalendarController> {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());
    return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: GetBuilder<CalendarController>(
              builder: (controller) {
                return TableCalendar(
                  /** 달력 내부 제스쳐 관리
                   * enum 값이 none이어야 캘린더 내부도 ListView 스크롤 터치가 먹음
                   * */
                  availableGestures: AvailableGestures.none,
                  /** required 3인방 + selectedDay*/
                  focusedDay: controller.focusedDay.value,
                  firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
                  lastDay: DateTime(DateTime.now().year, DateTime.now().month, 31),
                  /** 언어 설정 */
                  locale: 'ko-KR',
                  /** header 영역 */
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronVisible: false,
                      rightChevronVisible: false
                  ),
                  headerVisible: true,
                  /** <상단 요일 영역> */
                  daysOfWeekHeight: 30,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 17),
                      weekendStyle: TextStyle(fontSize: 17)
                  ),

                  /** <달력 기본 스타일,날짜 영역>-------- start*/
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.grey,),
                    weekendTextStyle: const TextStyle(color: Colors.grey),
                    outsideDaysVisible: false,
                    // selectedDay 동그라미 영역 크기 정하기
                    cellMargin: EdgeInsets.all(10),

                    todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent, width: 1.5)
                    ),
                    todayTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),

                    selectedDecoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  /** <달력 기본 스타일,날짜 영역>---------- end*/

                  /** <달력 내부 커스터마징 builder사용해서 뜯어 고치기-----------start >*/
                  calendarBuilders: CalendarBuilders(
                    // 기본 날짜 builder
                      defaultBuilder: (context,day,_) {
                        if (controller.eventsCompleteListLength(day)>0) {
                          // event가 존재하고 true인게 있는 날은 초록색으로 날짜 표시하기
                          return Center(child: Text('${day.day}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),));
                        }
                      },
                      // 이벤트 표시 마커를 어떻게 build 할지 커스터마징.
                      singleMarkerBuilder: (context, day,Event event){
                        return Container(
                          width: 5.5,
                          height: 5.5,
                          margin: EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                            // 손쉽게 event 값을 불러들여서 해결
                              color: event.complete?Colors.green:Colors.grey,
                              shape: BoxShape.circle
                          ),
                        );
                      }
                  ),
                  /** <달력 내부 커스터마징 builder사용해서 뜯어 고치기-----------end >*/

                  /** 이벤트 관리 */
                  eventLoader: (day) {
                    return controller.getEventsForDay(day);
                  },

                  /** 날짜 터치시 상호작용 */
                  onDaySelected: (DateTime selectedDay, _){
                    controller.updateSelectedDay(selectedDay);
                    Get.find<MissionController>().moveScroll();
                    },
                  selectedDayPredicate: (day){
                    return isSameDay(controller.selectedDay.value,day);
                  },
                );
              }
            )
          ),
          SizedBox(height: 8,),
          GetBuilder<CalendarController>(
            builder: (controller) {
              return AnimatedSwitcher(
                // 자연스러운 위젯 전환을 위해 AnimatedSwitcher 위젯 추가!
                duration: Duration(milliseconds: 200),
                child: Container(
                  key: ValueKey<int>(controller.selectedDay.value.day),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width:35,
                              height: 30,
                              child: Text('${controller.selectedDay.value.day}',style: TextStyle(fontSize: 25),)
                          ),
                          SizedBox(
                              width: 40,
                              height: 20,
                              child: Text(controller.getWeekDay(), style: TextStyle(fontSize: 18,color: Colors.blueGrey),)
                          ),
                          SizedBox(width: 15,),
                          Text('달성목표 ${controller.eventsCompleteListLength()} |',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          Text('미달성 목표 ${controller.getEventsForDay().length-controller.eventsCompleteListLength()}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 10,),

                      Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                        defaultColumnWidth: IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                              children: [
                                _buildTableCell(0),
                                _buildTableCell(1),
                              ]
                          ),
                          TableRow(
                              children: [
                                _buildTableCell(2),
                                _buildTableCell(3)
                              ]
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
                ;
            },
          )
        ]);
  }

  _buildTableCell(index) {
    return TableCell(
      child:
      Container(
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          height: 40,
          alignment: Alignment.center,
          child: Builder(
              builder: (context) {
                if (controller.makeTable(index)==null){
                  return Text('');
                } else {
                  return Text('${controller.makeTable(index)!.title}', style: TextStyle(color: controller.makeTable(index)!.complete?Colors.green:Colors.grey, fontWeight: FontWeight.bold),);
                }

              }
          )
      ),
    );
  }
}