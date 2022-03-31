class FriendModel{
  final String name;
  final String phoneNumber;
  String nickname;
  String imageUrl;
  int level;
  int exp;
  List tokens;


  FriendModel({
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.exp,
    required this.imageUrl,
    required this.level,
    required this.tokens

  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'exp': exp,
    'level': level,
    'imageUrl': imageUrl,
    'tokens':tokens

  };

}


