import 'package:client_connect/models/post_model.dart';
import 'package:client_connect/services/post_service.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==========================================
  // LOADING
  // ==========================================

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

  Future<String?> createPost(PostModel post) async {
    try {
      setLoading(true);

      await _postService.createPost(post);

      return null;
    } catch (e) {
      debugPrint("Create Post Error: $e");

      return "Failed to create post. Please try again.";
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // UPDATE POST
  // ==========================================

  Future<String?> updatePost({
    required String postId,
    required String description,
  }) async {
    try {
      setLoading(true);

      await _postService.updatePost(
        postId,
        description,
      );

      return null;
    } catch (e) {
      debugPrint("Update Post Error: $e");

      return "Failed to update post.";
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // DELETE POST
  // ==========================================

  Future<String?> deletePost(String postId) async {
    try {
      setLoading(true);

      await _postService.deletePost(postId);

      return null;
    } catch (e) {
      debugPrint("Delete Post Error: $e");

      return "Failed to delete post.";
    } finally {
      setLoading(false);
    }
  }
}