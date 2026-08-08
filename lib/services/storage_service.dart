import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  final Uuid _uuid = const Uuid();

  Future<List<String>> uploadPostImages({
    required String userId,
    required String postId,
    required List<File> images,
  }) async {
    final List<String> imageUrls = [];

    for (final image in images) {
      final String fileName = _uuid.v4();

      final Reference reference = _storage
          .ref()
          .child('posts')
          .child(userId)
          .child(postId)
          .child('$fileName.jpg');

      await reference.putFile(
        image,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      final String downloadUrl =
      await reference.getDownloadURL();

      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> deletePostImages({
    required String userId,
    required String postId,
  }) async {
    final Reference postReference = _storage
        .ref()
        .child('posts')
        .child(userId)
        .child(postId);

    try {
      final ListResult result =
      await postReference.listAll();

      for (final Reference file in result.items) {
        await file.delete();
      }

      for (final Reference folder in result.prefixes) {
        await _deleteFolder(folder);
      }
    } catch (e) {
      // Folder does not exist or is already empty.
    }
  }

  Future<void> _deleteFolder(
      Reference reference,
      ) async {
    final ListResult result =
    await reference.listAll();

    for (final Reference file in result.items) {
      await file.delete();
    }

    for (final Reference folder in result.prefixes) {
      await _deleteFolder(folder);
    }
  }
}