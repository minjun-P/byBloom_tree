import 'package:get/get.dart';
import 'calendar_model.dart';
/// 달력 내부 로직에 필요한 여러 코드를 모아놓음.
class CalendarController extends GetxController {

  // 중요한 변수 두개를 Observalbe 변수로 만든다.
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;

  // 핵심이 되는 메소드. Obx로 하니까 인식을 못해서(왜인진 모름) GetBuilder로 View 구현하고 update() 메소드 추가해줌.
  void updateSelectedDay(DateTime day) {
    selectedDay(day);
    update();
  }
  // 현재 selectedDay의 요일을 리턴해주는 함수
  String getWeekDay() {
    switch(selectedDay.value.weekday){
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return 'Thu';
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "일";
    }
  }

  // 기본적으로 selectedDay의 events를 리턴해주고
  // optional 파라미터에 값을 넣어줬을 때만 특정 날짜의 events를 리턴한다.
  List<Event> getEventsForDay([DateTime? eventCheckDay]) {
    if (eventCheckDay !=null){
      return events[eventCheckDay] ?? [];
    }
    return events[selectedDay.value] ?? [];
  }



  // 미션을 완수한 리스트의 길이를 뽑아내준다.
  int eventsCompleteListLength([DateTime? day]) {
    // 각 모든 날짜의 리스트 길이가 필요할 때만 제한적으로 사용 ( CaledarBuilder 사용시 )
    if (day != null) {
      List<Event> events = getEventsForDay(day);
      List<Event> completedEvents = events.where((event)=>event.complete==true).toList();
      return completedEvents.length;
    }
    // 일반적 사용 - 그냥 selectedDay의 길이 뽑아내기
    List list = getEventsForDay();
    return list.where((event) => event.complete == true).toList().length;
  }

  // events 리스트를 불러온 다음 map으로 만든다. 그럼 없는 인덱스로 인덱싱해도 오류가 아니라 null값을 리턴해서
  // 코드 진행하라 때 편리하다.
  Event? makeTable(int index) {
    List<Event> events = getEventsForDay();
    Map map = events.asMap();
    return map[index];
  }

}