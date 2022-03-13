import 'calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_model.dart';

/// 달력 위젯!!
class Calendar extends GetView<CalendarController> {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Text('${DateTime.now().month}월',style: const TextStyle(fontSize: 35,color: Colors.black,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),
          Container(
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
                  headerVisible: false,
                  /** <상단 요일 영역> */
                  daysOfWeekHeight: 30,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 19,color: Colors.grey,fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(fontSize: 19,color: Colors.grey,fontWeight: FontWeight.bold)
                  ),

                  /** <달력 기본 스타일,날짜 영역>-------- start*/
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                    weekendTextStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                    outsideDaysVisible: false,
                    // selectedDay 동그라미 영역 크기 정하기
                    cellMargin: const EdgeInsets.all(5),

                    todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent, width: 1.5)
                    ),
                    todayTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      fontSize: 14
                    ),

                    selectedDecoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
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
                          return Center(child: Text('${day.day}',style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),));
                        }
                      },
                      // 이벤트 표시 마커를 어떻게 build 할지 커스터마징.
                      singleMarkerBuilder: (context, day,Event event){
                        if (event.complete) {
                          return Container(
                            width: 5.5,
                            height: 5.5,
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              // 손쉽게 event 값을 불러들여서 해결
                                color: Colors.green,
                                shape: BoxShape.circle
                            ),
                          );
                        } else  {
                          // complete false 인 애들은 일단 임시로 빈컨테이너 리턴하게 해서 없는 것처럼 보이게 하자
                          return Container();
                        }
                      },
                  ),
                  /** <달력 내부 커스터마징 builder사용해서 뜯어 고치기-----------end >*/

                  /** 이벤트 관리 */
                  eventLoader: (day) {
                    return controller.getEventsForDay(day);
                  },

                  /** 날짜 터치시 상호작용 */
                  onDaySelected: (DateTime selectedDay, _){
                    controller.updateSelectedDay(selectedDay);
                    },
                  selectedDayPredicate: (day){
                    return isSameDay(controller.selectedDay.value,day);
                  },
                );
              }
            )
          ),
          const SizedBox(height: 8,),

        ]);
  }


}