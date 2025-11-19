import 'package:chat_app/features/chats/data/models/recent_chat_models.dart';
import 'package:chat_app/features/chats/data/repositories/recent_chat_repository.dart';
import 'package:flutter/material.dart';

class RecentChatViewModel extends ChangeNotifier {
  final RecentChatRepository _recentChatRepository;
  RecentChatViewModel(this._recentChatRepository);

  Stream<List<RecentChatModels>> getUserChats(String userId) {
    return _recentChatRepository.getUserChats(userId);
  }
}
