import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String? userImage;

  final String title;
  final String description;
  final String? budget;
  final String? technology;

  final List<String> images;
  final bool isAnonymous;

  final int likesCount;
  final int commentsCount;

  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.title,
    required this.description,
    this.budget,
    this.technology,
    this.images = const [],
    this.isAnonymous = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  // ==========================================
  // TO MAP
  // ==========================================

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,

      'title': title,
      'description': description,
      'budget': budget,
      'technology': technology,

      'images': images,
      'isAnonymous': isAnonymous,

      'likesCount': likesCount,
      'commentsCount': commentsCount,

      'createdAt': Timestamp.fromDate(
        createdAt,
      ),
    };
  }

  // ==========================================
  // FROM MAP
  // ==========================================

  factory PostModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return PostModel(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',

      userName: map['userName'] ?? '',
      userImage: map['userImage'],

      title: map['title'] ?? '',
      description: map['description'] ?? '',

      budget: map['budget'],
      technology: map['technology'],

      images: List<String>.from(
        map['images'] ?? [],
      ),

      isAnonymous:
      map['isAnonymous'] ?? false,

      likesCount:
      map['likesCount'] ?? 0,

      commentsCount:
      map['commentsCount'] ?? 0,

      createdAt:
      map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp)
          .toDate()
          : DateTime.now(),
    );
  }
}