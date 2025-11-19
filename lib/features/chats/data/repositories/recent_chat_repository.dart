import 'package:chat_app/features/chats/data/models/recent_chat_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentChatRepository {
  final FirebaseFirestore _firebaseFirestore;
  RecentChatRepository(this._firebaseFirestore);

  Stream<List<RecentChatModels>> getUserChats(String currentUserId) {
    return _firebaseFirestore
        .collection('chats')
        .where('userIds', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => RecentChatModels.fromDoc(e)).toList(),
        );
  }
}
