class FormValidator {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegx = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegx.hasMatch(email.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be 8+ chars with uppercase, lowercase, number & special char';
    }

    return null;
  }
}
