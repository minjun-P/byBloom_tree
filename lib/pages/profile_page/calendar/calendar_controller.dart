import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../tree_page/tree_controller.dart';
import 'calendar_model.dart';
import 'package:flutter/material.dart';
/// 달력 내부 로직에 필요한 여러 코드를 모아놓음.
class CalendarController extends GetxController {

  // 중요한 변수 두개를 Observalbe 변수로 만든다.
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).obs;

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
      return hashedEventList.value[DateTime(eventCheckDay.year,eventCheckDay.month,eventCheckDay.day)] ?? [];
    }
    return hashedEventList.value[DateTime(selectedDay.value.year,selectedDay.value.month,selectedDay.value.day)] ?? [];
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

  /// 디비랑 연동해 mission -> Event 로 만드는 로직
  Stream<Map<DateTime,List<Event>>> loadMissionCompleted(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    // 임시로 uid 고정값
    CollectionReference col = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('mission_completed');
    // 콜렉션 스냅샷 불러오기
    Stream<QuerySnapshot> completedSnapshot = col.snapshots();
    /// 스냅샷을 내가 필요한 형태로 가공 ==> Stream<Map>형태
    Stream<Map<DateTime,List<Event>>> stream = completedSnapshot.map((event) {
      // 다큐먼트 스냅샷이 모여있는 리스트 생성
      List<QueryDocumentSnapshot> docsList = event.docs;
      List<QueryDocumentSnapshot> filteredDocsList = docsList.where((element) {
        Map data = element.data() as Map<String,dynamic>;
        return data.isNotEmpty;
      }).toList();

      //
      Iterable<DateTime> datetimeList = filteredDocsList.map((document){
        Map<String,dynamic> temp = document.data() as Map<String,dynamic>;
        Map<String,dynamic> time = temp[temp.keys.elementAt(0)] as Map<String,dynamic>;
        Timestamp timestamp = time['createdAt'];
        DateTime date = timestamp.toDate();

        return DateTime(date.year,date.month,date.day);
      });
      Iterable<List<Event>> missionList = filteredDocsList.map((document){
        Map<String,dynamic> temp = document.data() as Map<String,dynamic>;
        // 미션 카테고리 따라서
        List<Event> missions =temp.keys.map((key){
          Map<String,dynamic> detail = temp[key] as Map<String,dynamic>;
          return Event(detail['contents'],true,category: key);
        }).toList();
        return missions;
      });
      Map<DateTime,List<Event>> result = Map.fromIterables(datetimeList, missionList);
      return result;
    });
    return stream;
  }
  var calendarEventList = RxMap<DateTime,List<Event>>({});
  Rx<LinkedHashMap<DateTime?, List<Event>>> hashedEventList = LinkedHashMap<DateTime?, List<Event>>(
    equals: isSameDay,
  ).obs;

  RxList selectedEventsList = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    calendarEventList.bindStream(loadMissionCompleted());
    ever(calendarEventList, (list){
      hashedEventList.value.addAll(calendarEventList);
      print(calendarEventList);
      update();
    });
    ever(selectedDay,(day){
      selectedEventsList.value = getEventsForDay().map((event)=>event.category!).toList();
      update();
    });
    Future.delayed(Duration(milliseconds: 1000)).then((value) => update());
    super.onInit();
  }



}