class AuthFormService {
  String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters.';
    }
    return null;
  }

  String? validateEmail(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return 'Email is required.';
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(normalizedValue)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters.';
    }
    return null;
  }

  String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  String? validatePasswordConfirmation({
    required String password,
    required String confirmation,
  }) {
    final passwordValidationMessage = validatePassword(password);
    if (passwordValidationMessage != null) {
      return passwordValidationMessage;
    }
    if (password != confirmation) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
