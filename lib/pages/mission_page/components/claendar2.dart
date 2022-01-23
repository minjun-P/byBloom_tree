import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar2 extends StatefulWidget {
  const Calendar2({Key? key}) : super(key: key);

  @override
  _Calendar2State createState() => _Calendar2State();
}

class _Calendar2State extends State<Calendar2> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2021,1,1),
      lastDay: DateTime(2022,1,31),
      locale: 'ko-KR',
      daysOfWeekHeight: 30,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 17),
        weekendStyle: TextStyle(fontSize: 17)
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: false,
        rightChevronVisible: false
      ),
      headerVisible: true,
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.grey,),
        weekendTextStyle: TextStyle(color: Colors.grey),
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green,width: 1.5)
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey
        )
      ),
    );
  }
}
