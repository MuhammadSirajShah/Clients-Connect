import 'dart:io';

import 'package:client_connect/models/user_profile_model.dart';
import 'package:client_connect/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Realtime Profile Stream
  Stream<UserProfileModel?> profileStream(String uid) {
    return _profileService.profileStream(uid);
  }

  // Get Profile
  Future<UserProfileModel?> getProfile(String uid) async {
    try {
      return await _profileService.getProfile(uid);
    } catch (e) {
      return null;
    }
  }

  // Create Profile
  Future<String?> createProfile(UserProfileModel profile) async {
    try {
      setLoading(true);

      await _profileService.createProfile(profile);

      return null;
    } catch (e) {
      return "Failed to create profile.";
    } finally {
      setLoading(false);
    }
  }

  // Update Profile
  Future<String?> updateProfile(UserProfileModel profile) async {
    try {
      setLoading(true);

      await _profileService.updateProfile(profile);

      return null;
    } catch (e) {
      return "Failed to update profile.";
    } finally {
      setLoading(false);
    }
  }

  // Upload Profile Image
  Future<String?> uploadProfileImage(
      String uid,
      File image,
      ) async {
    try {
      setLoading(true);

      final imageUrl = await _profileService.uploadProfileImage(
        uid,
        image,
      );

      return imageUrl;
    } catch (e) {
      return null;
    } finally {
      setLoading(false);
    }
  }
}