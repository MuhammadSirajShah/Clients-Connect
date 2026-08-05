import 'package:client_connect/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = "posts";

  // Create Post
  Future<void> createPost(PostModel post) async {
    await _firestore
        .collection(_collection)
        .doc(post.postId)
        .set(post.toMap());
  }

  // Get All Posts (Realtime)
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection(_collection)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Delete Post
  Future<void> deletePost(String postId) async {
    await _firestore
        .collection(_collection)
        .doc(postId)
        .delete();
  }

  // Update Post
  Future<void> updatePost(
      String postId,
      String description,
      ) async {
    await _firestore
        .collection(_collection)
        .doc(postId)
        .update({
      "description": description,
    });
  }
}