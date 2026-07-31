import 'package:client_connect/models/user_model.dart';
import 'package:client_connect/services/auth_service.dart';
import 'package:client_connect/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // =========================
  // SIGN UP
  // =========================

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);

      final userCredential = await _authService.signup(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return "Account could not be created.";
      }

      final user = UserModel(
        uid: firebaseUser.uid,
        name: name.trim(),
        email: firebaseUser.email ?? email.trim(),
        profileImage: null,
        createdAt: DateTime.now(),
      );

      await _userService.createUserProfile(
        user: user,
      );

      await _authService.sendEmailVerification();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "This email is already registered.";
      }

      if (e.code == "invalid-email") {
        return "Please enter a valid email address.";
      }

      if (e.code == "weak-password") {
        return "Password is too weak.";
      }

      if (e.code == "network-request-failed") {
        return "No internet connection.";
      }

      return e.message ?? "Something went wrong.";
    } catch (e) {
      return "Something went wrong. Please try again.";
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);

      await _authService.login(
        email: email,
        password: password,
      );

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // FORGOT PASSWORD
  // =========================

  Future<String?> forgotPassword({
    required String email,
  }) async {
    try {
      setLoading(true);

      await _authService.forgotPassword(
        email,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "User not found";
      }

      if (e.code == "invalid-email") {
        return "Invalid email";
      }

      return e.message ?? "Something went wrong";
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _authService.logout();
  }

  // =========================
  // CURRENT USER
  // =========================

  get currentUser => _authService.currentUser;

  // =========================
  // AUTH STATE
  // =========================

  Stream get authStateChanges =>
      _authService.authStateChanges;
}