// lib/features/auth/viewmodels/login_viewmodel.dart

// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/utils/form_validator.dart';

import '../../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final FormValidator _validator;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginViewModel(this._validator, this._authRepository, this._userRepository);

  // Form state
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  String? _generalError;
  bool _isLoading = false;

  // Success message for signup
  String? _successMessage;

  // Getters
  String get email => _email;
  String get password => _password;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get generalError => _generalError;
  String? get successMessage => _successMessage;
  bool get isLoading => _isLoading;

  // On email changed - logs input and clears error
  void onEmailChanged(String value) {
    _email = value.trim();

    // Clear error when user starts typing
    if (_emailError != null) {
      _emailError = null;
      notifyListeners();
    }

    // Clear general error
    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    // Log the input
    debugPrint('Email changed: $value');
  }

  // On password changed - logs input and clears error
  void onPasswordChanged(String value) {
    _password = value;

    // Clear error when user starts typing
    if (_passwordError != null) {
      _passwordError = null;
      notifyListeners();
    }

    // Clear general error
    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    // Log the input
    debugPrint('Password changed: $value');
  }

  // Validate all fields
  bool validateForm() {
    _emailError = _validator.validateEmail(_email);
    _passwordError = _validator.validatePassword(_password);

    notifyListeners();

    return _emailError == null && _passwordError == null;
  }

  // Login with Firebase
  Future<bool> login() async {
    if (!validateForm()) return false;

    _isLoading = true;
    _generalError = null;
    notifyListeners();

    try {
      final credential = await _authRepository.loginAccount(
        email: _email.trim(),
        password: _password,
      );

      // reset old token
      await FirebaseMessaging.instance.deleteToken();

      // get fresh token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      log('[LOG]: FCM Token on login: $fcmToken');

      // save to firestore
      if (fcmToken != null) {
        await _userRepository.saveFcmToken(
          uid: credential.user!.uid,
          fcmToken: fcmToken,
        );
      }

      // fcm token refresh listener
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint('new token: $newToken');

        _userRepository.saveFcmToken(
          uid: credential.user!.uid,
          fcmToken: newToken,
        );
      });

      debugPrint('Login successful - Email: $_email');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      _generalError = _getErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Convert Firebase error codes to user-friendly messages
  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    } else if (error.contains('invalid-credential')) {
      return 'Invalid email or password';
    } else {
      return 'An error occurred. Please try again';
    }
  }

  // Clear form
  void clearForm() {
    _email = '';
    _password = '';
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    _successMessage = null;
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _generalError = null;
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
