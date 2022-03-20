class UserModel{
  final String name;
  final String phoneNumber;
  final DateTime createdAt;
  String nickname;
  String imageUrl;
  int level;
  int exp;
  String Sex;
  double slidevalue;
  String birth;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.createdAt,
    required this.exp,
    required this.imageUrl,
    required this.level,
    required this.Sex,
    required this.birth,
    required this.slidevalue

});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'createdAt': createdAt,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl,
    'Sex':Sex,
    'birth':birth,
    'slidevalue':slidevalue


  };
}

