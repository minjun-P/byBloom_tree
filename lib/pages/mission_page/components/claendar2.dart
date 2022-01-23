import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'calendar_model.dart';


class Calendar2 extends StatefulWidget {
  const Calendar2({Key? key}) : super(key: key);

  @override
  _Calendar2State createState() => _Calendar2State();
}

class _Calendar2State extends State<Calendar2> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _selectedEvents.dispose();
    super.dispose();
  }
  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: TableCalendar(
            /** 달력 내부 제스쳐 관리 */
            availableGestures: AvailableGestures.none,
            /** required 3인방 */
            focusedDay: DateTime.now(),
            firstDay: DateTime(2021, 1, 1),
            lastDay: DateTime(2022, 1, 31),
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

            /** <달력 기본 스타일,날짜 영역>-------- */
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.grey,),
              weekendTextStyle: const TextStyle(color: Colors.grey),
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5)
              ),
              todayTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
              markerDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle
              ),
            ),
            /** <달력 기본 스타일,날짜 영역>---------- */
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context,day,_) {
                if (_getEventsForDay(day).length>0) {
                  return Center(child: Text('${day.day}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),));
                }
              }
            ),

            /** 이벤트 관리 */
            eventLoader: (day) {
              return _getEventsForDay(day);
            },

            /** 날짜 터치시 상호작용 */
            onDaySelected: (DateTime selectedDay, _){
              print(selectedDay.day);
              _selectedEvents.value = _getEventsForDay(selectedDay);
            },



          ),
        ),
        SizedBox(height: 8,),
        ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return Column(
                children: List.generate(
                    value.length,
                        (index)
                    => Container(
                      height: 80,
                      width: Get.width*0.8,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      alignment: Alignment.center,
                      child: Text('${value[index].toString()}'),
                    ))
              );
            }
        ),
        _buildMissionAchievement()
      ],
    )

      ;
  }
  Widget _buildMissionAchievement() {
    return Container(
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
              Text('8',style: TextStyle(fontSize: 25),),
              Text('Mon',style: TextStyle(fontSize: 20,color: Colors.blueGrey),),
              SizedBox(width: 15,),
              Text('달성목표 2 |',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              Text('미달성 목표 1',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 10,),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child:
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text('기도 15분하기',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                      ),
                    ),
                    TableCell(
                      child:
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text('생명의 삷 쓰기',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                      ),
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    TableCell(
                      child:
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text('설교노트 정리',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                      ),
                    ),
                    TableCell(
                      child:
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text('치킨 먹기')
                      ),
                    ),
                  ]
                )
              ],
            )
        ],
      ),
    );
  }
}



