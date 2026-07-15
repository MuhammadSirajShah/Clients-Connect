import 'package:client_connect/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  // SignUp Setup
  Future<String?> signup({
    required String email,
    required String password,
})async {
    try{
      setLoading(true);
      await _authService.signup(
          email: email,
          password: password
      );
      await _authService.sendEmailVerification();
      return null;
    } catch(e){
      if(e is FirebaseAuthException){
        switch(e.code){
          case "email-already-in-use":
            return "You are already registered.";
          case "invalid-email":
            return "Invalid email.";
          case "weak-password":
            return "Password is too weak.";

          default: return e.message;
        }
      }
      return e.toString();
    }
}

  // Login setup
  Future<String?> login({
    required String email,
    required String password,
})async {
    try{
      setLoading(true);
      await _authService.login(
          email: email,
          password: password
      );
      return null;
    }catch(e){
      if(e is FirebaseAuthException){
        switch(e.code){
          case "user-not-found":
            return "No account found.";
          case "wrong-password":
            return "Invalid password.";
          case "invalid-credential":
            return "Invalid email or password.";
          case "invalid-email":
            return "Invalid email.";
          default:
            return e.message;
        }
      }
      return e.toString();
    }
}

  // forgot Password Setup
  Future<String?> forgotPassword(String email) async{

    _isLoading = true;
    notifyListeners();
    final error = await _authService.resetPassword(email);

    _isLoading = false;
    notifyListeners();
    return error;
  }

  // logout Setup
  Future<void> logout() async{
    await _authService.logout();
  }
}