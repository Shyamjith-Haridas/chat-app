// lib/features/auth/viewmodels/signup_viewmodel.dart

import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/utils/form_validator.dart';

import '../../../login/data/repositories/auth_repository.dart';

class SignupViewModel extends ChangeNotifier {
  final FormValidator _validator;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignupViewModel(this._validator, this._authRepository, this._userRepository);

  // Form state
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Error state
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  // Loading state
  bool _isLoading = false;

  // Getters
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get generalError => _generalError;
  bool get isLoading => _isLoading;

  // On name changed - logs input and clears error
  void onNameChanged(String value) {
    _name = value;

    if (_nameError != null) {
      _nameError = null;
      notifyListeners();
    }

    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    debugPrint('Name changed: $value');
  }

  // On email changed - logs input and clears error
  void onEmailChanged(String value) {
    _email = value;

    if (_emailError != null) {
      _emailError = null;
      notifyListeners();
    }

    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    debugPrint('Email changed: $value');
  }

  // On password changed - logs input and clears error
  void onPasswordChanged(String value) {
    _password = value;

    if (_passwordError != null) {
      _passwordError = null;
      notifyListeners();
    }

    // Also revalidate confirm password if it exists
    if (_confirmPassword.isNotEmpty && _confirmPasswordError != null) {
      _confirmPasswordError = null;
      notifyListeners();
    }

    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    debugPrint('Password changed: $value');
  }

  // On confirm password changed - logs input and clears error
  void onConfirmPasswordChanged(String value) {
    _confirmPassword = value;

    if (_confirmPasswordError != null) {
      _confirmPasswordError = null;
      notifyListeners();
    }

    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }

    debugPrint('Confirm password changed: $value');
  }

  // Validate all fields
  bool validateForm() {
    bool ok = true;
    final emailValidation = _validator.validateEmail(_email);
    final passwordValidation = _validator.validatePassword(_password);

    _emailError = emailValidation;
    _passwordError = passwordValidation;

    if (_emailError != null || _passwordError != null) {
      ok = false;
      notifyListeners();
    }

    return ok;
  }

  // Sign up with Firebase
  Future<bool> signUp() async {
    if (!validateForm()) {
      return false;
    }

    _isLoading = true;
    _generalError = null;
    notifyListeners();

    try {
      // Create user account
      final user = await _authRepository.createAccount(
        email: _email.trim(),
        password: _password,
      );

      // Save usename in firebase auth
      await user.user!.updateDisplayName(_name);
      await user.user!.reload();

      // Save user details to firestore
      await _userRepository.saveUserDetails(
        uid: user.user!.uid,
        name: name,
        email: email,
      );

      // Sign out immediately after account creation
      // User needs to login with credentials
      await _authRepository.signOutAccount();

      debugPrint('Sign up successful - Email: $_email, Name: $_name');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Sign up error: $e');
      _generalError = _getErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Convert Firebase error codes to user-friendly messages
  String _getErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'An error occurred. Please try again';
    }
  }

  // Clear form
  void clearForm() {
    _name = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _generalError = null;
    notifyListeners();
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}
