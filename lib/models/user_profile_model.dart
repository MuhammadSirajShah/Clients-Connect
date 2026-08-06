import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final String bio;
  final List<String> skills;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.bio,
    required this.skills,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'bio': bio,
      'skills': skills,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
      bio: map['bio'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}