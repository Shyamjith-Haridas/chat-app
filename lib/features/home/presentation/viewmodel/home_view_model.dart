import 'dart:developer';

import 'package:chat_app/features/auth/login/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  HomeViewModel(this._authRepository);

  Future<void> logout() async {
    try {
      await _authRepository.signOutAccount();
    } catch (e) {
      log('[LOG]: Logout failed: $e');
    }
  }
}
