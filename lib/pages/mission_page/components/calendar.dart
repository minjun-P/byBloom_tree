import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: TableCalendar(
        headerVisible: false,
        daysOfWeekStyle: DaysOfWeekStyle(

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1
              )
            )
          )
        ),
          focusedDay: _focusedDay,
          firstDay: DateTime(2022,1,1),
          lastDay: DateTime(2022,1,31),
        calendarFormat: _calendarFormat,

        onDaySelected: (selectedDay, focusedDay) {
            print(selectedDay.day);
        },
        onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
        },
        daysOfWeekHeight: 60,
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            switch(day.weekday){
              case 1:
                return Center(child: Text('월'),);
              case 2:
                return Center(child: Text('화'),);
              case 3:
                return Center(child: Text('수'),);
              case 4:
                return Center(child: Text('목'),);
              case 5:
                return Center(child: Text('금'),);
              case 6:
                return Center(child: Text('토'),);
              case 7:
                return Center(child: Text('일',style: TextStyle(color: Colors.red),),);
            }
          },
          defaultBuilder: (context, day,_) {
            if(day.day%2==0){
              return Center(child:Text('${day.day}',style: TextStyle(color: Colors.green),));
            }
          }
        ),
        availableCalendarFormats: {CalendarFormat.month : 'Month'},
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: Colors.grey,fontSize: 15),
          weekendTextStyle: TextStyle(color: Colors.grey,fontSize: 15),
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(color: Colors.transparent,shape: BoxShape.circle,border: Border.all(color: Colors.green,width: 1.5)),
          todayTextStyle: TextStyle(color: Colors.black)



        ),

      ),
    );
  }
}
