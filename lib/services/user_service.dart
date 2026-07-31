

import 'package:client_connect/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required UserModel user,
}) async{
    await _firestore
        .collection("users")
        .doc(user.uid)
        .set(user.toMap());
  }
  Future<UserModel?> getUserProfile(
      String uid,
      )async {
    final documentSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .get();
    if (!documentSnapshot.exists){
      return null;
    }
    final date = documentSnapshot.data();

    if(date == null){
      return null;
    }
    return UserModel.fromMap(date);
  }
  Future<void> updateUserProfile({
    required String uid,
    required Map<String,dynamic> data,
})async{
    await _firestore
        .collection('users')
        .doc(uid)
        .update(data);
  }
}