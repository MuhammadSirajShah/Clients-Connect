import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_connect/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ==========================================
  // POSTS COLLECTION
  // ==========================================

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection('posts');

  // ==========================================
  // CREATE POST
  // ==========================================

  Future<void> createPost(PostModel post) async {
    await _postsCollection
        .doc(post.postId)
        .set(post.toMap());
  }

  // ==========================================
  // GET POSTS - REALTIME
  // ==========================================

  Stream<List<PostModel>> getPosts() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return PostModel.fromMap(
              doc.data(),
            );
          },
        ).toList();
      },
    );
  }

  // ==========================================
  // UPDATE POST
  // ==========================================

  Future<void> updatePost(
      String postId,
      String description,
      ) async {
    await _postsCollection
        .doc(postId)
        .update({
      'description': description,
    });
  }

  // ==========================================
  // DELETE POST
  // ==========================================

  Future<void> deletePost(String postId) async {
    await _postsCollection
        .doc(postId)
        .delete();
  }
}