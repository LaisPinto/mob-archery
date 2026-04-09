class ProfileFormService {
  String? validateName(String value) {
    if (value.trim().isEmpty) return 'Name is required.';
    if (value.trim().length < 2) return 'Name must contain at least 2 characters.';
    return null;
  }

  String? validateEmail(String value) {
    if (value.trim().isEmpty) return 'E-mail is required.';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Invalid e-mail address.';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return null; // blank = keep current password
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }
}
