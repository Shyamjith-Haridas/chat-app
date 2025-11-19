import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;

  ChatMessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessageModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      messageId: doc.id,
      senderId: data['senderId'] as String,
      receiverId: data['receiverId'] as String,
      text: data['text'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
