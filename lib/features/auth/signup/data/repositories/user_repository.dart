import 'package:chat_app/features/users/data/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserDetails({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get users - stream rt
  Stream<List<UsersModel>> getAllUsers(String currentUserId) {
    final data = _firestore
        .collection('users')
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots();

    final userList = data.map((snapshot) {
      return snapshot.docs.map((doc) {
        return UsersModel.fromMap(doc.data());
      }).toList();
    });

    return userList;
  }

  // fcm token - own
  Future<void> saveFcmToken({
    required String uid,
    required String fcmToken,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // fetch receiver fcm token
  Future<String?> getUserFcmToken(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['fcmToken'];
    } catch (e) {
      rethrow;
    }
  }
}
