class Forest {
  String title;
  bool isStar;
  int chatCount;

  Forest(this.title,{this.isStar = false, this.chatCount = 0});


}

List<Forest> forests = [
  Forest('가족숲'),
  Forest('청년1조 숲',chatCount: 154),
  Forest('봉천동 1조 숲',isStar: true),
  Forest('낙성대동 2조 숲',chatCount: 200)
];