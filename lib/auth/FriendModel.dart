class FriendModel{
  final String name;
  final String phoneNumber;
  final String profileImage;
  String nickname;
  int level;
  int exp;
  List tokens;
  String uid;


  FriendModel({
    required this.name,
    required this.phoneNumber,
    required this.nickname,
    required this.exp,
    required this.level,
    required this.tokens,
    required this.uid,
    required this.profileImage

  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
    'exp': exp,
    'level': level,
    'tokens':tokens,
    'uid':uid,
    'profileImage':profileImage

  };

}


