import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_connect/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ==========================================
  // POSTS COLLECTION
  // ==========================================

  CollectionReference<Map<String, dynamic>>
  get _postsCollection =>
      _firestore.collection('posts');

  // ==========================================
  // USER POSTS COLLECTION
  // ==========================================

  CollectionReference<Map<String, dynamic>>
  _userPostsCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('posts');
  }

  // ==========================================
  // CREATE POST
  // ==========================================

  Future<void> createPost(PostModel post) async {
    final batch = _firestore.batch();

    // Global post
    final globalPostReference =
    _postsCollection.doc(post.postId);

    // User's own post
    final userPostReference =
    _userPostsCollection(post.userId)
        .doc(post.postId);

    final postData = post.toMap();

    // Save in global posts
    batch.set(
      globalPostReference,
      postData,
    );

    // Save in user's posts
    batch.set(
      userPostReference,
      postData,
    );

    await batch.commit();
  }

  // ==========================================
  // GET POSTS - REALTIME
  // ==========================================

  Stream<List<PostModel>> getPosts() {
    return _postsCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
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
  // GET USER POSTS - REALTIME
  // ==========================================

  Stream<List<PostModel>> getUserPosts(
      String userId,
      ) {
    return _userPostsCollection(userId)
        .orderBy(
      'createdAt',
      descending: true,
    )
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
  // GET SINGLE POST
  // ==========================================

  Future<PostModel?> getPostById(
      String postId,
      ) async {
    final doc =
    await _postsCollection.doc(postId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return PostModel.fromMap(
      doc.data()!,
    );
  }

  // ==========================================
  // UPDATE POST
  // ==========================================

  Future<void> updatePost({
    required String postId,
    required String userId,
    required String description,
  }) async {
    final batch = _firestore.batch();

    final updateData = {
      'description': description,
    };

    // Global post
    batch.update(
      _postsCollection.doc(postId),
      updateData,
    );

    // User's post
    batch.update(
      _userPostsCollection(userId).doc(postId),
      updateData,
    );

    await batch.commit();
  }

  // ==========================================
  // DELETE POST
  // ==========================================

  Future<void> deletePost({
    required String postId,
    required String userId,
  }) async {
    final batch = _firestore.batch();

    // Delete global post
    batch.delete(
      _postsCollection.doc(postId),
    );

    // Delete user's post
    batch.delete(
      _userPostsCollection(userId).doc(postId),
    );

    await batch.commit();
  }

  // ==========================================
  // LIKE POST
  // ==========================================

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    final postReference =
    _postsCollection.doc(postId);

    final likeReference = postReference
        .collection('likes')
        .doc(userId);

    final likeDocument =
    await likeReference.get();

    if (likeDocument.exists) {
      return;
    }

    await _firestore.runTransaction(
          (transaction) async {
        final postSnapshot =
        await transaction.get(
          postReference,
        );

        if (!postSnapshot.exists) {
          throw Exception(
            'Post does not exist.',
          );
        }

        final data =
            postSnapshot.data() ?? {};

        final currentLikes =
        (data['likesCount'] ?? 0) as int;

        transaction.set(
          likeReference,
          {
            'userId': userId,
            'createdAt':
            FieldValue.serverTimestamp(),
          },
        );

        transaction.update(
          postReference,
          {
            'likesCount':
            currentLikes + 1,
          },
        );

        // Update user's copy
        final userIdOfPost =
        data['userId'] as String?;

        if (userIdOfPost != null &&
            userIdOfPost.isNotEmpty) {
          transaction.update(
            _userPostsCollection(
              userIdOfPost,
            ).doc(postId),
            {
              'likesCount':
              currentLikes + 1,
            },
          );
        }
      },
    );
  }

  // ==========================================
  // UNLIKE POST
  // ==========================================

  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    final postReference =
    _postsCollection.doc(postId);

    final likeReference = postReference
        .collection('likes')
        .doc(userId);

    final likeDocument =
    await likeReference.get();

    if (!likeDocument.exists) {
      return;
    }

    await _firestore.runTransaction(
          (transaction) async {
        final postSnapshot =
        await transaction.get(
          postReference,
        );

        if (!postSnapshot.exists) {
          throw Exception(
            'Post does not exist.',
          );
        }

        final data =
            postSnapshot.data() ?? {};

        final currentLikes =
        (data['likesCount'] ?? 0) as int;

        final newLikes =
        currentLikes > 0
            ? currentLikes - 1
            : 0;

        transaction.delete(
          likeReference,
        );

        transaction.update(
          postReference,
          {
            'likesCount': newLikes,
          },
        );

        final userIdOfPost =
        data['userId'] as String?;

        if (userIdOfPost != null &&
            userIdOfPost.isNotEmpty) {
          transaction.update(
            _userPostsCollection(
              userIdOfPost,
            ).doc(postId),
            {
              'likesCount': newLikes,
            },
          );
        }
      },
    );
  }

  // ==========================================
  // CHECK USER LIKE
  // ==========================================

  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    final document =
    await _postsCollection
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .get();

    return document.exists;
  }

  // ==========================================
  // COMMENTS COLLECTION
  // ==========================================

  CollectionReference<Map<String, dynamic>>
  _commentsCollection(
      String postId,
      ) {
    return _postsCollection
        .doc(postId)
        .collection('comments');
  }

  // ==========================================
  // ADD COMMENT
  // ==========================================

  Future<void> addComment({
    required String postId,
    required String commentId,
    required String userId,
    required String userName,
    String? userImage,
    required String comment,
  }) async {
    final postReference =
    _postsCollection.doc(postId);

    final commentReference =
    _commentsCollection(postId)
        .doc(commentId);

    await _firestore.runTransaction(
          (transaction) async {
        final postSnapshot =
        await transaction.get(
          postReference,
        );

        if (!postSnapshot.exists) {
          throw Exception(
            'Post does not exist.',
          );
        }

        final data =
            postSnapshot.data() ?? {};

        final currentComments =
        (data['commentsCount'] ?? 0) as int;

        transaction.set(
          commentReference,
          {
            'commentId': commentId,
            'userId': userId,
            'userName': userName,
            'userImage': userImage,
            'comment': comment,
            'createdAt':
            FieldValue.serverTimestamp(),
          },
        );

        final newComments =
            currentComments + 1;

        transaction.update(
          postReference,
          {
            'commentsCount':
            newComments,
          },
        );

        final userIdOfPost =
        data['userId'] as String?;

        if (userIdOfPost != null &&
            userIdOfPost.isNotEmpty) {
          transaction.update(
            _userPostsCollection(
              userIdOfPost,
            ).doc(postId),
            {
              'commentsCount':
              newComments,
            },
          );
        }
      },
    );
  }

  // ==========================================
  // GET COMMENTS - REALTIME
  // ==========================================

  Stream<List<Map<String, dynamic>>>
  getComments(String postId) {
    return _commentsCollection(postId)
        .orderBy(
      'createdAt',
      descending: false,
    )
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return {
              'commentId': doc.id,
              ...doc.data(),
            };
          },
        ).toList();
      },
    );
  }

  // ==========================================
  // DELETE COMMENT
  // ==========================================

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final postReference =
    _postsCollection.doc(postId);

    final commentReference =
    _commentsCollection(postId)
        .doc(commentId);

    await _firestore.runTransaction(
          (transaction) async {
        final postSnapshot =
        await transaction.get(
          postReference,
        );

        if (!postSnapshot.exists) {
          return;
        }

        final data =
            postSnapshot.data() ?? {};

        final currentComments =
        (data['commentsCount'] ?? 0) as int;

        final newComments =
        currentComments > 0
            ? currentComments - 1
            : 0;

        transaction.delete(
          commentReference,
        );

        transaction.update(
          postReference,
          {
            'commentsCount':
            newComments,
          },
        );

        final userIdOfPost =
        data['userId'] as String?;

        if (userIdOfPost != null &&
            userIdOfPost.isNotEmpty) {
          transaction.update(
            _userPostsCollection(
              userIdOfPost,
            ).doc(postId),
            {
              'commentsCount':
              newComments,
            },
          );
        }
      },
    );
  }
}