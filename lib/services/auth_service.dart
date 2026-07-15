import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword(String email)async{
    try{
      await _auth.sendPasswordResetEmail(
          email: email
      );
      return null;
    } on FirebaseAuthException catch(e){
      return e.message;
    }catch(e){
      return e.toString();
    }
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;

    if (user != null &&
        !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}