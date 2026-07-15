
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.createdAt
});

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        profileImage: map['profileImage'],
        createdAt: DateTime.parse(map['createdAt']),
    );
  }
}