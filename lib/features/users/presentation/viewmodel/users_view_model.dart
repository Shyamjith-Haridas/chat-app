import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:chat_app/features/users/data/models/users_model.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UsersViewModel(this._userRepository);

  Stream<List<UsersModel>>? _usersStream;
  Stream<List<UsersModel>>? get usersStream => _usersStream;

  void loadAllUsers(String? currentUserId) {
    // final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      _usersStream = _userRepository.getAllUsers(currentUserId);
      notifyListeners();
    }
  }
}
