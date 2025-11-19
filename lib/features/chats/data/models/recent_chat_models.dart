import 'package:cloud_firestore/cloud_firestore.dart';

class RecentChatModels {
  final String chatId;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final List<String> userIds;

  RecentChatModels({
    required this.chatId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.userIds,
  });

  factory RecentChatModels.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecentChatModels(
      chatId: doc.id,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] ?? Timestamp.now(),
      userIds: List<String>.from(data['userIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'userIds': userIds,
    };
  }
}
