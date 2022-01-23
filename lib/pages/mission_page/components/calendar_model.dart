import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

final events = LinkedHashMap(
  equals: isSameDay,
)..addAll(eventSource);


Map<DateTime,dynamic> eventSource = {
  DateTime(2022,1,3) : [Event('event1'),Event('event1.1'),Event('event1.2')],
  DateTime(2022,1,5) : [Event('event2')],
  DateTime(2022,1,8) : [Event('event3')],
  DateTime(2022,1,11) : [Event('event4')],
};


class Event {
  String title;
  Event(this.title);

  @override
  String toString() => title;
}