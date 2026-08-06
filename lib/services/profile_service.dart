import 'dart:io';

import 'package:client_connect/models/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _collection = "users";

  // Create Profile
  Future<void> createProfile(UserProfileModel profile) async {
    await _firestore
        .collection(_collection)
        .doc(profile.uid)
        .set(profile.toMap());
  }

  // Get Profile
  Future<UserProfileModel?> getProfile(String uid) async {
    final doc =
    await _firestore.collection(_collection).doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return UserProfileModel.fromMap(doc.data()!);
  }

  // Realtime Profile
  Stream<UserProfileModel?> profileStream(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      return UserProfileModel.fromMap(doc.data()!);
    });
  }

  // Update Profile
  Future<void> updateProfile(UserProfileModel profile) async {
    await _firestore
        .collection(_collection)
        .doc(profile.uid)
        .update(profile.toMap());
  }

  // Upload Profile Image
  Future<String> uploadProfileImage(
      String uid,
      File image,
      ) async {
    final ref = _storage
        .ref()
        .child("profile_images")
        .child("$uid.jpg");

    await ref.putFile(image);

    return await ref.getDownloadURL();
  }
}