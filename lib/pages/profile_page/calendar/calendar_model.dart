import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

// 데이터를 Event 객체로 만들어놓음. 공식문서에서 이렇게 관리하기를 추천
class Event {
  // title -> 미션 명
  String title;
  // complete -> 달성 여부
  bool complete;
  // category
  String? category;

  Event(this.title, this.complete,{this.category});

  @override
  String toString() {
    if (category==null){
      return 'Event title:'+title+'category: ';
    } else {
      return 'Event title:'+title+' category: '+category!;
    }
  }
}

// Map형태로 이렇게 데이터를 직접 코딩해서 만들어 놓음.
Map<DateTime,List<Event>> eventSource = {
  DateTime(2022,4,1) : [Event('5분 기도하기',false),Event('교회 가서 인증샷 찍기',true),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2022,3,5) : [Event('5분 기도하기',false),Event('치킨 먹기',true),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2022,3,8) : [Event('5분 기도하기',false),Event('자기 셀카 올리기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2022,3,11) : [Event('5분 기도하기',false),Event('가족과 저녁식사 하기',true),Event('QT하기',true)],
  DateTime(2022,3,13) : [Event('5분 기도하기',false),Event('교회 가서 인증샷 찍기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2022,3,15) : [Event('5분 기도하기',false),Event('치킨 먹기',false),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2022,3,18) : [Event('5분 기도하기',false),Event('자기 셀카 올리기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2022,3,20) : [Event('5분 기도하기',true),Event('자기 셀카 올리기',true),Event('QT하기',true),Event('셀 모임하기',true),],
  DateTime(2022,3,21) : [Event('5분 기도하기',false),Event('가족과 저녁식사 하기',true),Event('QT하기',false)]
};

// 주환, 직접 신경쓰진 않아도 됨. 이부분은 그냥 공식문서 추천 방식이라서 위의 map을 LinkedHashMap으로 진화시킨겨

final events = LinkedHashMap(
  equals: isSameDay,
)..addAll(eventSource);



