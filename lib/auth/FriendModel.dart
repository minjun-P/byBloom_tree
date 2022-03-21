class FriendModel{
  final String name;
  final String phoneNumber;
  String nickname;
  String imageUrl;
  int level;
  int exp;


  FriendModel({
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.exp,
    required this.imageUrl,
    required this.level,

  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl

  };

}


