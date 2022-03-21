class UserModel{
  final String name;
  final String phoneNumber;
  final DateTime createdAt;
  String nickname;
  String imageUrl;
  int level;
  int exp;
  String sex;
  double slideValue;
  String birth;


  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.createdAt,
    required this.exp,
    required this.imageUrl,
    required this.level,
    required this.sex,
    required this.birth,
    required this.slideValue

});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'createdAt': createdAt,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl,
    'Sex':sex,
    'birth':birth,
    'slideValue':slideValue


  };
}

