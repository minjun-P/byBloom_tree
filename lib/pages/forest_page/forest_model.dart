class Forest {
  String name;
  Message latestMessage;
  int unreadCount;

  Forest({
    required this.name,
    required this.latestMessage,
    required this.unreadCount
});
}

class Message {
  String content;
  DateTime dateTime;
  String user;
  Message({
    required this.content,
    required this.dateTime,
    this.user = '나'
  });
  String getTime() {
    // 같은 날짜면
    if (DateTime.now().difference(dateTime).inDays==0){
      // 오후면
      if (dateTime.hour>12){
        return '오후${dateTime.hour-12}:${dateTime.minute}';
      } else {
        return '오전${dateTime.hour}:${dateTime.minute}';
      }
    } else {
      return '${DateTime.now().difference(dateTime).inDays}일 전';
    }

  }
}

List<Message> messageList = [
  Message(
      content: '오늘 집에 몇시에 들어올거야? 나는 좀 늦게 들어올 것 같아. 바쁜 일이 생겼거든',
      dateTime: DateTime(2022,2,3,15,22)
  ),
  Message(
      content: '저번에 목사님이 말씀하신 성경퀴즈 대회 나가실 분 있으신가요?',
      dateTime: DateTime(2022,2,3,15,22)
  ),
  Message(
      content: '사진 3장을 보냈습니다.',
      dateTime: DateTime(2022,2,3,15,22)
  ),
  Message(
      content: '고생 많으셨습니다... ㅜㅜㅜ 다들 고생하셨어요',
      dateTime: DateTime(2022,2,3,15,22)
  ),
  Message(
      content: '아 어제 사진 있는 사람? ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ......',
      dateTime: DateTime(2022,2,3,15,22)
  )
];

List<Forest> forestList = [
  Forest(name: '가족 숲',latestMessage: messageList[0],unreadCount: 10 ),
  Forest(name: '리더모임',latestMessage: messageList[1],unreadCount: 20 ),
  Forest(name: '쌉인싸모임',latestMessage: messageList[2],unreadCount: 12 ),
  Forest(name: '티미 셀',latestMessage: messageList[3],unreadCount: 102 ),
  Forest(name: '룰루 팸',latestMessage: messageList[4],unreadCount: 1 )
];

List<Message> messages = [
  Message(
    content: '목사님이 이나 언니 내려오래요....!',
    dateTime: DateTime.now(),
    user: '이여온'
  ),
  Message(
      content: '아 제가 알기론 그거 그냥 본당 마이크때문인 것 같아요. 제가 대신 가서 한번 볼게용!',
      dateTime: DateTime.now(),
      user: '김도균'
  ),
  Message(
      content: '혹시 오늘 찬양인도가 누구죠??',
      dateTime: DateTime.now(),
      user: '이보성'
  ),
  Message(
      content: '인영이 아닌가요? 지금 올라가 있던데?',
      dateTime: DateTime.now(),
      user: '박지수'
  ),
  Message(
      content: '아 오늘 저 아니예요!! 희준 오빠라고 들었어요',
      dateTime: DateTime.now(),
  ),
  Message(
      content: '아아 넵 희준이한테 전화해볼게요',
      dateTime: DateTime.now(),
      user: '이보성'
  ),
  Message(
      content: '넵~~!!',
      dateTime: DateTime.now(),
  ),
];