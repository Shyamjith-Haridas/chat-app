import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:chat_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  final _firestore = FirebaseFirestore.instance;
  final _userRepository = UserRepository();
  final _notificationRepository = NotificationRepository(
    baseUrl: "https://notification-server-y924.onrender.com",
  );

  // Get consiste chatid for users
  String getChatId(String userId1, String userId2) {
    final ids = [userId1, userId2];
    ids.sort();
    return ids.join("_");
  }

  // Send message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final chatId = getChatId(senderId, receiverId);
    final timestamp = Timestamp.now();

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final message = ChatMessageModel(
      messageId: messageRef.id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: timestamp,
    );

    // save message
    await messageRef.set(message.toMap());

    // update recent chat node
    await _firestore.collection('chats').doc(chatId).set({
      'userIds': [senderId, receiverId],
      'lastMessage': text,
      'lastMessageTime': timestamp,
    }, SetOptions(merge: true));

    // get receiver token
    final token = await _userRepository.getUserFcmToken(receiverId);

    // send push notifications
    if (token != null) {
      await _notificationRepository.sendPushNotification(
        token: token,
        title: "New Message",
        body: text,
      );
    }
  }

  // Get real-time message
  Stream<List<ChatMessageModel>> getMessages(String userId1, String userId2) {
    final chatId = getChatId(userId1, userId2);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessageModel.fromDoc(doc))
              .toList(),
        );
  }
}
