import 'dart:io';

import 'package:client_connect/models/post_model.dart';
import 'package:client_connect/services/post_service.dart';
import 'package:client_connect/services/storage_service.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ==========================================
  // REALTIME POSTS
  // ==========================================

  Stream<List<PostModel>> get postsStream {
    return _postService.getPosts();
  }

  // ==========================================
  // CREATE POST
  // ==========================================

  Future<String?> createPost({
    required PostModel post,
    required List<File> images,
  }) async {
    try {
      setLoading(true);

      List<String> imageUrls = [];

      if (images.isNotEmpty) {
        imageUrls =
        await _storageService.uploadPostImages(
          userId: post.userId,
          postId: post.postId,
          images: images,
        );
      }

      final finalPost = PostModel(
        postId: post.postId,
        userId: post.userId,
        userName: post.userName,
        userImage: post.userImage,
        title: post.title,
        description: post.description,
        budget: post.budget,
        technology: post.technology,
        images: imageUrls,
        isAnonymous: post.isAnonymous,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        createdAt: post.createdAt,
      );

      await _postService.createPost(
        finalPost,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Create Post Error: $e",
      );

      return "Failed to create post.";
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // UPDATE POST
  // ==========================================

  Future<String?> updatePost({
    required String postId,
    required String userId,
    required String description,
  }) async {
    try {
      setLoading(true);

      await _postService.updatePost(
        postId: postId,
        userId: userId,
        description: description,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Update Post Error: $e",
      );

      return "Failed to update post.";
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // DELETE POST
  // ==========================================

  Future<String?> deletePost({
    required String postId,
    required String userId,
  }) async {
    try {
      setLoading(true);

      await _postService.deletePost(
        postId: postId,
        userId: userId,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Delete Post Error: $e",
      );

      return "Failed to delete post.";
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // LIKE POST
  // ==========================================

  Future<String?> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _postService.likePost(
        postId: postId,
        userId: userId,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Like Post Error: $e",
      );

      return "Failed to like post.";
    }
  }

  // ==========================================
  // UNLIKE POST
  // ==========================================

  Future<String?> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _postService.unlikePost(
        postId: postId,
        userId: userId,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Unlike Post Error: $e",
      );

      return "Failed to unlike post.";
    }
  }

  // ==========================================
  // CHECK LIKE
  // ==========================================

  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    try {
      return await _postService
          .hasUserLikedPost(
        postId: postId,
        userId: userId,
      );
    } catch (e) {
      debugPrint(
        "Check Like Error: $e",
      );

      return false;
    }
  }

  // ==========================================
  // ADD COMMENT
  // ==========================================

  Future<String?> addComment({
    required String postId,
    required String commentId,
    required String userId,
    required String userName,
    String? userImage,
    required String comment,
  }) async {
    try {
      await _postService.addComment(
        postId: postId,
        commentId: commentId,
        userId: userId,
        userName: userName,
        userImage: userImage,
        comment: comment,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Add Comment Error: $e",
      );

      return "Failed to add comment.";
    }
  }

  // ==========================================
  // REALTIME COMMENTS
  // ==========================================

  Stream<List<Map<String, dynamic>>>
  commentsStream(
      String postId,
      ) {
    return _postService.getComments(
      postId,
    );
  }

  // ==========================================
  // DELETE COMMENT
  // ==========================================

  Future<String?> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _postService.deleteComment(
        postId: postId,
        commentId: commentId,
      );

      return null;
    } catch (e) {
      debugPrint(
        "Delete Comment Error: $e",
      );

      return "Failed to delete comment.";
    }
  }
}